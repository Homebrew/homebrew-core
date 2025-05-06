class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.12.0.tar.gz"
  sha256 "82675a4e831274415f0086f24afa8e97a701a6bba6f5c69baeeec0d924ca4542"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f8185ea9bbeedc96ea608745f1ba4133cfa4078c9e3dda166b9bc37ac44e862"
    sha256 cellar: :any,                 arm64_sonoma:  "e1a3dd72449d34d70ad5e648cbf29be4178d2a92dcb958815605d9787424110b"
    sha256 cellar: :any,                 arm64_ventura: "849149fbaac0a4ae8fc499b0139a9888f466e7ed5bcd7f6cd3628270a3793470"
    sha256 cellar: :any,                 sonoma:        "02e376f6ada9698cf63dfe5630df5cd6ade1116c01870c9972cb5d8a50333e23"
    sha256 cellar: :any,                 ventura:       "d39d584caa351aacaad3b41767a494e38dcb1e9d2e176ca5cf30a3769288d3cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17a5c36a075a6a3955d3d14a0bea81f8bbc11285c64b56337e7df989c2b58349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879165782c8fd51a7ecd86a3bc20cd14d003f9d2766edd89bc9b12824a694940"
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
