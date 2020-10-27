class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.1.2.tar.gz"
  sha256 "1bd940a72af556a4e685086ca0d3a363d71e3cfedeffb36f865f38d44386f94a"
  license "MIT"

  bottle do
    cellar :any
    sha256 "916037c7be0a4d68aefc50766972bd9af94d1aed6c4f799464df7ddfc757597b" => :catalina
    sha256 "0a75e9085381291184131f31551bbce6fce440587165a93ca577805fdb077a5c" => :mojave
    sha256 "19d5820ecbf9fb4eba3f799c2bf0c1aca9924dcb3e7b82b041bf13c757d828fd" => :high_sierra
  end

  depends_on "crystal" => :build
  depends_on "jq"
  depends_on "libevent"
  depends_on "libyaml"

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
