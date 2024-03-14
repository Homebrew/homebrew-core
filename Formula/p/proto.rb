class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.31.5.tar.gz"
  sha256 "f91035029b144538602e8577c25a043a8778ea0924fd9e2011c0e4697cee047a"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9722aea6804925621c1560f89cb4edb8b1471cc2ba91d3734157b473476e063"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d32c51dd9efefb46fbb1edb289a3a34f89c68e035c20cb32293b4000244b48f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b33ffed31f00aa5b42f4dccb64d7186ef8db6a033247d2ce3bcaaf10b85401b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1877661db11aaeec6df74f053f58756c0ca0ec5f3433a6c57eb9451839e78268"
    sha256 cellar: :any_skip_relocation, ventura:        "517ac934e430419ebd4348d382c39b24936f6fd730a4f4b83765b506cd807116"
    sha256 cellar: :any_skip_relocation, monterey:       "1893111e52b044cb0e653b9c11cf034569eaa201fdbbd5e393328cbe0e2bf633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00e84f33b7ce1831e182809274d8ba3cecbeeb00600829fd254bbd1681f0917f"
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
