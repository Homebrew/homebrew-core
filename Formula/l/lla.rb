class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "c569bedf08c3207c0e17d965766f53140e4eaf12957b9b73ed6b861a9135ae59"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf1e20da96070951c983b403314e1ad5c658a42ad807df224e45f39aff83b40d"
    sha256 cellar: :any,                 arm64_sequoia: "630636099977c0dbaa2346a7dded270a7b3a5d3f572e45f7fe6ef0a0343d6a6b"
    sha256 cellar: :any,                 arm64_sonoma:  "d53a9640dd93354b67707cb2e4b16794842444cf66dd5c0d58d91b8795761631"
    sha256 cellar: :any,                 sonoma:        "9e2274069c723d7c4ec8ee4ece6fa618d98e48802184127136f7188d704b94e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38f35550e2e5baee45b6d7e81bfac0bceba55478a35ffe8460229a55481d680f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0cbc8a0e4afdcb561ed37461d71aec8c2c92cee24bfa33c4c5ac9bf8cdeb51d"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    (buildpath/"plugins").each_child do |plugin|
      next unless plugin.directory?

      plugin_path = plugin/"Cargo.toml"
      next unless plugin_path.exist?

      system "cargo", "build", "--jobs", ENV.make_jobs.to_s,
                               "--locked", "--lib", "--release",
                               "--manifest-path=#{plugin_path}"
    end
    lib.install Dir["target/release/*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      The Lla plugins have been installed in the following directory:
        #{opt_lib}
    EOS
  end

  test do
    test_config = testpath/".config/lla/config.toml"

    system bin/"lla", "init"

    output = shell_output("#{bin}/lla config")
    assert_match "Current configuration at \"#{test_config}\"", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
