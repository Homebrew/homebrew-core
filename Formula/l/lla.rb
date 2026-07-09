class Lla < Formula
  desc "High-performance, extensible alternative to ls"
  homepage "https://github.com/chaqchase/lla"
  url "https://github.com/chaqchase/lla/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "abc4f2801aab23333ebcc986aa5cf5378d3bdfcd63bc74476b5db80487e3b2a8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "40055baf694911f5fdd239bc70488bc8da98374e73d5bfbcd08adf67859b63d9"
    sha256 cellar: :any, arm64_sequoia: "5f99aba06cb65cf61dd1eb924159904120f24fc6b7566dad6fac102612c13bd3"
    sha256 cellar: :any, arm64_sonoma:  "d0a1c22acb0317318991557b23a978c214ead8af023ec728b457861fb94d43d9"
    sha256 cellar: :any, sonoma:        "2988e8d56bb7305a67f46b60e12bb2f5406e3a7d66b4711972fff71e73b9f0c2"
    sha256 cellar: :any, arm64_linux:   "e6d8013ea09e8d1bd2a27bc4517f42d9df182dfe06e895b50dfe9ef941d5056a"
    sha256 cellar: :any, x86_64_linux:  "2081c9a9640316f0efe9cd26e10a42ad4b6733730d1c27fa00477e90d3d0c191"
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
