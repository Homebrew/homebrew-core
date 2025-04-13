class JxlOxide < Formula
  desc "JPEG XL decoder"
  homepage "https://github.com/tirr-c/jxl-oxide"
  url "https://github.com/tirr-c/jxl-oxide/archive/refs/tags/0.11.4.tar.gz"
  sha256 "3a8ae80ef96c5784bb7136e8260565e7df6ec6ae09fa17c3037aa8fd7bba8e1a"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3244cf5848e86466a3a539ebc41f7ce81e13350a5d2c020ae9bf21833d1aca7f"
    sha256 cellar: :any,                 arm64_sonoma:  "3f62b55bbd1bd510100cdc622f90390f3de0d697dfa1bfc5fad585eff886b2c4"
    sha256 cellar: :any,                 arm64_ventura: "ccaed443bc7841f418f013df84629899a839352e46e08a271900ed0ae445bbd1"
    sha256 cellar: :any,                 sonoma:        "c88821bc2a078108f71ff5830ec8e9706e6393cd8ede41456d69e8e3103ce2ea"
    sha256 cellar: :any,                 ventura:       "7fb0046d3316e5316560643e748a11b4163251df84b039142298c4b4ef4fb2f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4923559a0b40a4852053ff4149a60395114cbc5747c7e40314a6398eb05fcfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c410f2ad6d3e8bb92ffe3a1e7128419c9b150fb8ad03a3369f4a0658524c9fd8"
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
