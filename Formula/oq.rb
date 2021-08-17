class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.3.0.tar.gz"
  sha256 "5bfb23b0c527f45eacd40485779c708b1a05dd36015b50b84df29c2ac3f6cdac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 big_sur:      "d2103ce8be5e0323e7b3a05be2f8ddd87a8b1dab4a738bb8b4910d218d405330"
    sha256 cellar: :any,                 catalina:     "a0cfe0c660845ce97db5870370f0d7d8b456471d4cf78c4ab01dadae6e59d9c7"
    sha256 cellar: :any,                 mojave:       "4163e9f867d0b15c64f522f2319185d5d1085426171cea15cd0e7654644d54bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bac03c6db8b41c7d5e6dc5b3d53a64852e8155eefcf502f4f62e04ecb5c08291"
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
