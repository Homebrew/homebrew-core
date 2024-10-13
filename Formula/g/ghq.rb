class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.6.2",
      revision: "d79add20f26e7c079295e79496310ce3b6eabed1"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0b1e5f1d94c1342f87b9ab5772b932b6b7249dd31d5191c993f11911aceed228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0de47f832a39f6a6fadc1efb785798fc30b96095241c0e26abafa214beaffeb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1d5ccc6c9d8d68f72a0a53b78ba47a42085b3d54a3ebf9d1ee813f677af263d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b255e56677ea5870dbfa2431f8ef8434320df212c8c0dceb241d483aa0c9c49"
    sha256 cellar: :any_skip_relocation, sonoma:         "32865ce27aecdd29458fa0371995995f83d1dfd7baa85774a922ab93a8d430f6"
    sha256 cellar: :any_skip_relocation, ventura:        "b6359c97d379ee92cdd952af9851ab2ae095d40ccde886dfabe9f65a43c9815e"
    sha256 cellar: :any_skip_relocation, monterey:       "0c03d1110c19c45bd4fec65f74903ae47b9d18e755deb10f16b049074ae4fcc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a8e7c24af366f7136c2d5825175517ba12a5e042456f1354780ef24f0e217d"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
