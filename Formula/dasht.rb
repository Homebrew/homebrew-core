class Dasht < Formula
  desc "Search API docs offline, in your terminal or browser"
  homepage "https://sunaku.github.io/dasht"
  url "https://github.com/sunaku/dasht/archive/v2.4.0.tar.gz"
  sha256 "5ea43b0f7461e124d46b991892dedc8dcf506ccd5e9dc94324f7bdf6e580ff73"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94ad1a43dc67fa38cef44f163f2577fbc8821cef94f5bb8cf00ca999d72e0364"
  end

  depends_on "socat"
  depends_on "sqlite"
  depends_on "w3m"
  depends_on "wget"

  def install
    bin.install Dir["bin/*"]
    man.install "man/man1"
  end

  test do
    system "#{bin}/dasht-docsets-install", "--force", "bash"
    assert_equal "Bash\n", shell_output("#{bin}/dasht-docsets")
  end
end
