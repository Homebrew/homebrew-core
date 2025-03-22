class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.11.3.tar.gz"
  sha256 "9492c2542b1116168c805737844780d5509b7afbe129f956499f6ccd9eeba412"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1e549075f1d10f4041d452124061af52ef69300dfe7e40c29442a8aaa6b5e0a"
    sha256 cellar: :any,                 arm64_sonoma:  "c61df2c670718e8fde9a1b150bd4062ee51b63191b34d1ad765de2823c7c7a4e"
    sha256 cellar: :any,                 arm64_ventura: "cd1666a34d73b38a3062e3fb5ff54c8232b4e1a6ef1939db4b14a48b3ab14432"
    sha256 cellar: :any,                 sonoma:        "a7e5a1b94056370a4088538d25668b6c26915cfbd53f4fb08222d9021dd6c77c"
    sha256 cellar: :any,                 ventura:       "639481aaeaa5e4290dd926de35201ba9c4ba1f2d62b6cec2d144d66dd58160f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3400a8869006b1ed8cabb36b1fb8237239d2f9a8150aa1d32009820c59083197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3539329b71056e6218a03dc407c296fe195efca346132ac4965c77c37e21ce1a"
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
    assert_path_exists testpath/"out.png"
  end
end
