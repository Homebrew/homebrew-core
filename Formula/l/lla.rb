class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "05a0d342f3cdc971eea3d0e495c64888bffc5aabda3e91bbc99efb23746c8bee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a9eed19cc56579e57d73a046badff2e19090eab93c4d938a3624c087e987814"
    sha256 cellar: :any,                 arm64_sequoia: "80316b2ba8591a143cf2fd13feed1f685e45fd4d657d598a5f756f2743cc78fa"
    sha256 cellar: :any,                 arm64_sonoma:  "3d58be4d4daac2f22ad85c74d8307ad5061da6da58bec6d0fe79bbab248c83ef"
    sha256 cellar: :any,                 sonoma:        "67c6e6b63294d34df2a800d7b49a10dd3d3ff0f11486a49fca001a7e72b53132"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757ae967c44f63b58ad5f53c354b8ae182e15852eb136d39a9c20c56a4c50d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f7f96b4f5f8304e9be221108d7ec208a3bc39e12a7da03c070fba202ded8917"
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

    system bin/"lla", "init", "--default"

    output = shell_output("#{bin}/lla config")
    assert_match "Config file: #{test_config}", output

    system bin/"lla"

    # test lla plugins
    system bin/"lla", "config", "--set", "plugins_dir", opt_lib

    system bin/"lla", "--enable-plugin", "git_status", "categorizer"
    system bin/"lla"

    assert_match "lla #{version}", shell_output("#{bin}/lla --version")
  end
end
