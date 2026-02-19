class Gauth < Formula
  desc "Google Authenticator in your terminal"
  homepage "https://github.com/pcarrier/gauth"
  url "https://github.com/pcarrier/gauth/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "5c98287f5c209b9f02ec62ede4abd4117aa3ca738fbcb4153a6ec1e966f492a8"
  license "ISC"
  head "https://github.com/pcarrier/gauth.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e07c7cf508ea13a153defdeb3c81b662d5672d7572edecac06920a093cecb1ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d91ac9029a1df98f1c2a3b5318f364c4b826c3f267e8d420fa389b5fc536dd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d91ac9029a1df98f1c2a3b5318f364c4b826c3f267e8d420fa389b5fc536dd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d91ac9029a1df98f1c2a3b5318f364c4b826c3f267e8d420fa389b5fc536dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e2838fc31e6a7dd13880b2f95ef69d7732e8db0832feeec7f30b6ec18354b1"
    sha256 cellar: :any_skip_relocation, ventura:       "51e2838fc31e6a7dd13880b2f95ef69d7732e8db0832feeec7f30b6ec18354b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1e7e417bad6562df6256368f6ec1c99816222be6dd5e05af4c600cd38509469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f0fe17b342e5ff16879bea09f90bdf1ab70f33a9dea3b3ba9fbf3cfbf47028d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    refute_empty pipe_output "#{bin}/gauth demo --add", "JBSWY3DPEHPK3PXP"
    assert_match(/demo(\s+\d{6}){3}/, shell_output(bin/"gauth"))
  end
end
