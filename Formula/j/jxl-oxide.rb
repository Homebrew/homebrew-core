class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.9.1.tar.gz"
  sha256 "c021cc62999124daed4568c74efec10995772bad3e861563947df676d2d61c97"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70a3940e1b28ee44e283b267302021da682625b331086bf7d61ce340a8363b84"
    sha256 cellar: :any,                 arm64_sonoma:  "437c47748d10e5f03e804aa53d21e25ddf3430cb68cee5771f47996f735bb208"
    sha256 cellar: :any,                 arm64_ventura: "0698478296e730911ac9f269b49315c86fc1f650070ad91857764ec6e15b0679"
    sha256 cellar: :any,                 sonoma:        "529f909da58eb490f0d193fd724ff9dc8f07acc95f7f0a84b7ef6e5fc7965795"
    sha256 cellar: :any,                 ventura:       "f965dbe1dcd8029bfc21ce624906b27b82b90c70e2c45512397db11b660507fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "898436c08e00b731a906679f22b889640a8d14d8c251e1b09e9571fcab7d5d80"
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
