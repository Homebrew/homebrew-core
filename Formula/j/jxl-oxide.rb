class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.9.0.tar.gz"
  sha256 "8bdf5fa43409d16dfbd03f63a6a4f4eab291f7601c86a34c4269ea1993b1f8b3"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "699f59535a8939112f7229d42b1e4380533ed53af1ce7afb9996df63779372ba"
    sha256 cellar: :any,                 arm64_sonoma:  "7753fcf0e901f74c727d93beb3d99d8b1b58a533b528163d0a6db0a47ecb45bd"
    sha256 cellar: :any,                 arm64_ventura: "780877207ca535aa68f2dd1eb8c35185064465c4428122e3eafd52c86435c0c0"
    sha256 cellar: :any,                 sonoma:        "59288ce338b49bfea941cd7fc3fc7919ebb7fd18ccc9d85c27371ce91f5a7212"
    sha256 cellar: :any,                 ventura:       "cd9353f71b309aa306b559fb5a76e209b530099748a5f882ee062069332b9d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34e738e48c37542e302954436a1210563d6b45e3581c2b2abe7779102692d1d"
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
