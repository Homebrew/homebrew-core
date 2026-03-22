class Dasht < Formula
  desc "Search API docs offline, in your terminal or browser"
  homepage "https://sunaku.github.io/dasht"
  url "https://github.com/sunaku/dasht/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "5ea43b0f7461e124d46b991892dedc8dcf506ccd5e9dc94324f7bdf6e580ff73"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "14af08c8719ce7e688faa8b061141624a912960bc57d53499161428f08820b21"
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
    # Avoid test failure from GitHub API rate limit by creating fallback files
    (testpath/".cache/dasht/master").write <<~JSON
      {
        "ref": "refs/heads/master",
        "node_id": "MDM6UmVmMTEyMzkyNzk6cmVmcy9oZWFkcy9tYXN0ZXI=",
        "url": "https://api.github.com/repos/Kapeli/feeds/git/refs/heads/master",
        "object": {
          "sha": "a6a68e3648364e4c2ebbe0da7d29d9e723723115",
          "type": "commit",
          "url": "https://api.github.com/repos/Kapeli/feeds/git/commits/a6a68e3648364e4c2ebbe0da7d29d9e723723115"
        }
      }
    JSON
    (testpath/".cache/dasht/a6a68e3648364e4c2ebbe0da7d29d9e723723115").write <<~JSON
      {
        "sha": "a6a68e3648364e4c2ebbe0da7d29d9e723723115",
        "url": "https://api.github.com/repos/Kapeli/feeds/git/trees/a6a68e3648364e4c2ebbe0da7d29d9e723723115",
        "tree": [
          {
            "path": "Bash.xml",
            "mode": "100755",
            "type": "blob",
            "sha": "fc5a54826f8976e581d7069454e0aeb8f46babe7",
            "size": 359,
            "url": "https://api.github.com/repos/Kapeli/feeds/git/blobs/fc5a54826f8976e581d7069454e0aeb8f46babe7"
          }
        ],
        "truncated": false
      }
    JSON

    system bin/"dasht-docsets-install", "--force", "bash"
    assert_equal "Bash\n", shell_output(bin/"dasht-docsets")
  end
end
