class GoJsonnet < Formula
  desc "Go implemention of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.15.0.tar.gz"
  sha256 "cddc3462151de4c5c65183b613895575db06297edd12a63e740f09e5e0ed98dd"
  head "https://github.com/google/go-jsonnet.git"

  depends_on "go" => :build

  conflicts_with "jsonnet", :because => "both install binaries with the same name"

  def install
    system "go", "build", "-o", bin/"jsonnet", "./cmd/jsonnet"
    # jsonnetfmt will only be added with the next release
    # system "go", "build", "-o", bin/"jsonnetfmt", "./cmd/jsonnetfmt"
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
