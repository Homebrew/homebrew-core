class Odiff < Formula
  desc "Very fast SIMD-first image comparison library (with nodejs API)"
  homepage "https://github.com/dmtrKovalenko/odiff"
  url "https://github.com/dmtrKovalenko/odiff/archive/refs/tags/v4.3.8.tar.gz"
  sha256 "5a28709727303cd47c9562d530ca97e19de13a7d2260fa20af16685635881a9f"
  license "MIT"
  head "https://github.com/dmtrKovalenko/odiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ba57aa2f95b0600cdde6f8a1ce4436bec7d4ba65248afd3e58f9a870522ca27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75f5998d2e85a2696e30cd7f9092a7e0c5341d6108783013006294108d22f14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a6cf9e64f73899f9869fbaf1451178f49725633d0b474c8d77d5eebd707c495"
    sha256 cellar: :any_skip_relocation, sonoma:        "df118da73d35e38d5ea7eaa27bf8eeb604cdf927ab5d9be6bb5e9cb97cfb8b89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80a184807590001738930f42eb3a8fe3b9edefe5f30292f05ea6ba1b7533f535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7683d0832d5b0b06ed3300ca1d7c4200a7f8e0bd1054df9741d79771245cff9a"
  end

  depends_on "zig@0.15" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odiff --version 2>&1")

    assert_match "Images are identical",
      shell_output("#{bin}/odiff #{test_fixtures("test.png")} #{test_fixtures("test.png")} 2>&1")
  end
end
