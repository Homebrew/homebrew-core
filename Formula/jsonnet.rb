class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.11.2.tar.gz"
  sha256 "c7c33f159a9391e90ab646b3b5fd671dab356d8563dc447ee824ecd77f4609f8"
  head "https://github.com/google/jsonnet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "085740ce03c6801c58895b554ab23eae2ac8a8e2a1c528519324ccf543965e42" => :mojave
    sha256 "c146c572e65547f42d39580bbaed91539928c7d54ed6c1970d24e4507c53d638" => :high_sierra
    sha256 "b35454f33de80b8129bab932aa4979374bc729a4b69211e3ac2800ac4a47849a" => :sierra
    sha256 "813122fb2e3cb40932a4c270ed9b9163055df3898a2868bda9e18cf06b403e24" => :el_capitan
  end

  depends_on :macos => :mavericks

  needs :cxx11

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
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
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
