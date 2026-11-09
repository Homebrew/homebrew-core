class CniPlugins < Formula
  desc "Container Network Interface plugins"
  homepage "https://www.cni.dev"
  url "https://github.com/containernetworking/plugins/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "15a36f0a88e90704126d2d523a9704c4cab2439a4a19c9ac23961b31c2a311c6"
  license "Apache-2.0"
  head "https://github.com/containernetworking/plugins.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9384e41b4f5d791dff9407dc851a97fc79a10229e6692c4a4abedb714bb4f35f"
    sha256 cellar: :any,                 x86_64_linux: "26bce17624be1acbaa85052ed436a36e1d0069b04a92ef9ae1d858799d96eea6"
  end

  keg_only "plugin binaries are not intended to be under the $PATH"

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    buildpath.glob("plugins/{meta,main,ipam}/*").each do |plugin_path|
      basename = plugin_path.basename
      next if basename.to_s == "windows"

      system "go", "build", *std_go_args(output: bin/basename), plugin_path
    end
  end

  test do
    # Inspect supported CNI spec versions.
    ENV["CNI_COMMAND"] = "VERSION"
    output = JSON.parse shell_output("#{opt_bin}/bridge")
    assert_includes output["supportedVersions"], "1.1.0"
  end
end
