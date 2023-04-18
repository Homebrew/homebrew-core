class GitUrlSub < Formula
  desc "Recursively substitute remote URLs for multiple repos"
  homepage "https://gosuri.github.io/git-url-sub"
  url "https://github.com/gosuri/git-url-sub/archive/1.0.1.tar.gz"
  sha256 "6c943b55087e786e680d360cb9e085d8f1d7b9233c88e8f2e6a36f8e598a00a9"
  license "MIT"
  head "https://github.com/gosuri/git-url-sub.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95bb0b9c90b3c5fd928714791ed4dc800a3e25ddd52dd3dbdd295e1eb5fdb6da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95bb0b9c90b3c5fd928714791ed4dc800a3e25ddd52dd3dbdd295e1eb5fdb6da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8975feb6b79a015095edec52863982710396e64089ad4f3ff5ad8e0258c5d86b"
    sha256 cellar: :any_skip_relocation, ventura:        "95bb0b9c90b3c5fd928714791ed4dc800a3e25ddd52dd3dbdd295e1eb5fdb6da"
    sha256 cellar: :any_skip_relocation, monterey:       "95bb0b9c90b3c5fd928714791ed4dc800a3e25ddd52dd3dbdd295e1eb5fdb6da"
    sha256 cellar: :any_skip_relocation, big_sur:        "826dfdc4c81aa33b3962bec4280c0e0167b74f98103b028c49cff97383c06ef5"
    sha256 cellar: :any_skip_relocation, catalina:       "e35658a190c074ad5bb88578e34c91f8751b24ea297cf5b2eac9729c8eb9e814"
    sha256 cellar: :any_skip_relocation, mojave:         "f8f1a14a4d3cbc359b741111b56f5c47d252946784501e934fbdc5f82cbd2ed8"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4eca101481773e802431bc9fc264f5f2db309595d0faf0c02886a559c31baa91"
    sha256 cellar: :any_skip_relocation, sierra:         "2fcf47332e070caed126fef2be0a1108a23e18a9d1ba80b6059b45a417af1b31"
    sha256 cellar: :any_skip_relocation, el_capitan:     "cf954ff293abbcaf8816c8142b5762ebe7601107f76530f6bab0edea71e2d609"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "origin", "foo"
    system "#{bin}/git-url-sub", "-c", "foo", "bar"
    assert_match(/origin\s+bar \(fetch\)/, shell_output("git remote -v"))
  end
end
