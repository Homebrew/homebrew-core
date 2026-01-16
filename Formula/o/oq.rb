class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "66b2d879b6e2061121c50b8e584ce82f95fe79348bf3696ca38e5910a6c42495"
  license "MIT"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "023cabb88d541a227fe92c766625d0c1cd39a4d754d632db66d3c50b2e569fe2"
    sha256 cellar: :any,                 arm64_sequoia: "9c6c9f859e94646a4a4ee19c52ca6a458fb606e39f37476211bde90df945f16b"
    sha256 cellar: :any,                 arm64_sonoma:  "74da5986b16f5183f91c22f10fc515f24f4c96ddf2db01484357e43ed818da84"
    sha256 cellar: :any,                 sonoma:        "eb071190d60a7ca25bfdd41b2f7b6e6532cc67fa2de3ca2de9eed499e98c882e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcbe0948bfc1edc6f5fc03b667784348d8b3a4213a5a2970a0ad1c564795e1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b40019bdaf79268a1b35432bd8a5af1529a3cbcce8bc7b5eaa1b434e6d10b1"
  end

  depends_on "crystal" => :build

  depends_on "bdw-gc"
  depends_on "jq"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    system "strip", "./bin/oq"
    bin.install "./bin/oq"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oq --version")

    assert_equal(
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root><foo>1</foo><bar>2</bar></root>\n",
      pipe_output("#{bin}/oq -o xml --indent 0 .", '{"foo":1, "bar":2}'),
    )
    assert_equal "{\"age\":12}\n", pipe_output("#{bin}/oq -i yaml -c .", "---\nage: 12")
  end
end
