class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.16.2.tar.gz"
  sha256 "b4125f0cf58b1ad1d2ebdb708397a5d82e7f12f02222f7a3dff9c11d9e053654"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b56a985e95b6b8d8ace945c7f889a85d7a5f3dce37c57d69be0ae57968e9264"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2fad4d57d28a0f3ffd23b2b0f22b2955d26268e83e6e5869aad27e737b24a61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85b37715e352047425898b2358caa9c748c09407448fc56e50b8c25468ebe95"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b7eeaf37a94a94c699b43806345d52994e1c4e7b2629762b71db6c016e086c1"
    sha256 cellar: :any_skip_relocation, ventura:        "59ec1dd88729b03a1b1f4c049a477ad2fe649ee0535a64bdb855fe74a29887cb"
    sha256 cellar: :any_skip_relocation, monterey:       "75242ef145304a223c97d6b3a5b5017ab12c05bdaed92f32ea5a4388adc7c278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9260e3e5ecb77080f5aee2f300a60b35c2006e71fbcb741de07913e158488ae9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
