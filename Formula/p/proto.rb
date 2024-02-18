class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "a564e4c8a4d2483b19e02bd1b3cdac5db4ad61cc0e2d217203f0a641897ba7f4"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ff9de367ee78ce1ddb03e7c0ae6d9db3731f6dc02df3f573f9273bbf7e56fda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89f68a66e5fe549d9c9d2c3f12880a58e22760ff0e2fb2cbc05fb456adc1fcce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f74d7ca82eb84749599fbeca604ce23e99a575129dd71ad13e074c745cc714c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f87967d15e4e1e5ca83e05469a5889fc1b24633239b41ce915a572eb70aed3c0"
    sha256 cellar: :any_skip_relocation, ventura:        "217b7f50c7d7b34490c0cb6a39e37e980598ff6abd97a1e36a5950adae95c770"
    sha256 cellar: :any_skip_relocation, monterey:       "09139c5aed760d0aa0b2bf0a7f753501bf189ef4f6a7596f2317157269bc84be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc53763103d5d98759323c4721685d6b311d9c1b446207c5c64bad99895982b"
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
