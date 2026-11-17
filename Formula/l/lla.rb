class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "578bd6d4e89044988d140962c47a9618c74f101cb861802a9ab8cc2a708833d5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f75041876a988a034368fbf0392228ed3b19760f178d0108a984f7b92d8e9a99"
    sha256 cellar: :any, arm64_tahoe:       "ea9d236b0f1659f2c806b106e80143f63dfeceb2ea0a30b29e62004c82e863b2"
    sha256 cellar: :any, arm64_sequoia:     "b461cca144b6605017146c615adbb27d49cc417fb3c8b7e7588456b5d42d6cae"
    sha256 cellar: :any, arm64_linux:       "e29fec62e9034ede647f33bff027b93d9a1e319e7ac2a5325191cb9dbf6b601f"
    sha256 cellar: :any, x86_64_linux:      "ee22f53541367393b83ec17f24e789f678f7a21506c2e44b85b6213aa5545488"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lla")

    generate_completions_from_executable(bin/"lla", "completion")

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
