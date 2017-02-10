class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data."
  homepage "https://google.github.io/jsonnet/doc/"
  url "https://github.com/google/jsonnet/archive/v0.9.3.tar.gz"
  sha256 "25f21410acb3e1a9c8ced2a9d416cc39af70a0e4e12fb52c48f4eb4ac25bc938"

  bottle do
    cellar :any_skip_relocation
    sha256 "feea87cf10eeb7595fd4411b5901f7a707da125883a4edfdc4e83b5031b98d4f" => :sierra
    sha256 "089e61f679ceb1b4957cdef07ae71984cf090a9e2c249df23d51cb9e1b0f961e" => :el_capitan
    sha256 "3f52bff807faa0b55d343554d1d02a71611bfc148180582e61a5f749fbf87628" => :yosemite
  end

  needs :cxx11

  depends_on :macos => :mavericks

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    (testpath/"example.jsonnet").write <<-EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name" => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name" => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
