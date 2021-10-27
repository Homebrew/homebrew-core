class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.2.1",
      revision: "dd139fb46cb7c1a3b19bca7a0c3762090c7c522f"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99932f495196aeb90f4fefbff02ab6c4ab8e6b23ff91b5f68acb6ca0fd28ebc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b1f5f18b219a60f8d86556e0e6542edb7e9e8fb010bbf55ab83859e32ba5f00"
    sha256 cellar: :any_skip_relocation, monterey:       "0a9dde6a51cf71edde229e6478a8a2155c72469ebda1daae965d055de02d6ce1"
    sha256 cellar: :any_skip_relocation, big_sur:        "82fd83decb4539c9c0050d59a240c37149cf61ff5d6b6b6e47e7d6cba83c4d2d"
    sha256 cellar: :any_skip_relocation, catalina:       "8a337adf03ab11238253364863890654ebb92b6cc0b602658c54017059f4f6b5"
    sha256 cellar: :any_skip_relocation, mojave:         "983535fe9c12471da7b4cb2c72035dd602e525f3bcc26579d2d865a5c9cc263c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7a52d8fb22234e9c3ee2ab8ab48fae4a47a0b7c2b13da13fa96de8377b9f8c4"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
