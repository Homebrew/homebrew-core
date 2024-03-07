class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.31.4.tar.gz"
  sha256 "3c3bfca0d171bcb0b3921894ba2500aafadf99860e331b8c946403c567e8a1cc"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbeb5d50ea2930b43e6f83b9e540e3f6791eb52778ff26ecbe00dde9fc1c62bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "330e01889d2e84e14f2067e6b242c127dcf3fa3ab38525d67bcff349181d1dac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92d903b668035d9bb9b65a0b9e4bc1f668e3a9de04cc51bf7ee8473e2d1e5c7f"
    sha256 cellar: :any_skip_relocation, sonoma:         "05910c9bacddc403692f0fcdc6024371c5bfedadbe1bb3ad3faff42b83c191d5"
    sha256 cellar: :any_skip_relocation, ventura:        "adc4dee0d6d5b22a68621a07f67fbc27b3a67a555bd8e83fbd0557f3900dbba8"
    sha256 cellar: :any_skip_relocation, monterey:       "96d61f8f12271e26c13c9d857b812f69dbe0f13a0c9f0a6cc4237fa0133ef250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec941fcb69985e5d5005dbf4d3a7093c63e9f4d9a8c8aeca0d868da0559213d6"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end
