class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.3.4.tar.gz"
  sha256 "9e99c9ba292c466ca39fb7f6d0053f9fe13c2768a7493d1ef88ea2ca2e0d0ca0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f881c126af64b040e201046d551b1271b033004874fd6a245622d9fc360072d"
    sha256 cellar: :any,                 arm64_monterey: "0ae85bcb68114e264bce9def780201dab80edaebc91a15811799976c42fc5682"
    sha256 cellar: :any,                 arm64_big_sur:  "a24d7e3301c02d8878d6b91371d48d40f9f659d678e8702785d59130d6374fee"
    sha256 cellar: :any,                 ventura:        "09c18e63d77bdaad60afe431d07905ed214e93dd05b211c0c4925aee9528b1c3"
    sha256 cellar: :any,                 monterey:       "54a718d39d431feed30e2930557a6b97076d387194e9fd2534036cbcb415f1e0"
    sha256 cellar: :any,                 big_sur:        "6a560c164ee5ffb25c9449f3956d8e454b74ffa4681c2845e66c4df31f21cfab"
    sha256 cellar: :any,                 catalina:       "130986726eb1f832c75c22742d59674368b27f7c26685f0ca239067bdcc4be7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a9602d92baeaf93b02ff375f669b1dc3b07f39926b1db40362601cb5b70e315"
  end

  depends_on "crystal" => :build

  depends_on "bdw-gc"
  depends_on "jq"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "pcre"

  uses_from_macos "libxml2"

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    system "strip", "./bin/oq"
    bin.install "./bin/oq"
  end

  test do
    assert_equal(
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root><foo>1</foo><bar>2</bar></root>\n",
      pipe_output("#{bin}/oq -o xml --indent 0 .", '{"foo":1, "bar":2}'),
    )
    assert_equal "{\"age\":12}\n", pipe_output("#{bin}/oq -i yaml -c .", "---\nage: 12")
  end
end
