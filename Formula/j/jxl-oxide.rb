class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.11.1.tar.gz"
  sha256 "6b466453e3bb9c3d2220175e088202e98654ab4425dcaf80e88b2b06b63c21f6"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8185dcf1e2ad3b9532b65cccc9342e6e766798c01f70c9e1da44c8427d734574"
    sha256 cellar: :any,                 arm64_sonoma:  "75fc324a6be8ed3faf56c4629a228aa4bd833668d0155ad78d1dbce0e58d0221"
    sha256 cellar: :any,                 arm64_ventura: "fd42401f1f9e54c989d97df00deadcfccb0f54a4ff55c15ad187ad5923151e78"
    sha256 cellar: :any,                 sonoma:        "85362548bc7639d2127cdacad6736c2090a874eec04bcf5495b8bd94f20a3c71"
    sha256 cellar: :any,                 ventura:       "8969be819ed44b23fb32978d412b860d82ce9860ab695160f15377a56c8fa293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e82a0de0daa8f1ce4fe82f783f471d8953fbfc172600d562f35de0cb0c07a8d"
  end

  depends_on "rust" => :build
  depends_on "little-cms2"

  def install
    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/jxl-oxide-cli")
  end

  test do
    resource "sunset-logo-jxl" do
      url "https://github.com/libjxl/conformance/blob/5399ecf01e50ec5230912aa2df82286dc1c379c9/testcases/sunset_logo/input.jxl?raw=true"
      sha256 "6617480923e1fdef555e165a1e7df9ca648068dd0bdbc41a22c0e4213392d834"
    end

    resource("sunset-logo-jxl").stage do
      system bin/"jxl-oxide", "input.jxl", "-o", testpath/"out.png"
    end
    assert_predicate testpath/"out.png", :exist?
  end
end
