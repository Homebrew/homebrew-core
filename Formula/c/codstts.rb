class Codstts < Formula
  desc "Code statistics tool for analyzing project language distribution"
  homepage "https://github.com/zheng0116/codstts"
  url "https://github.com/zheng0116/codstts/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "31e6b46b8f43a52a4b036d07b50ea7faa11f562c01582ecda6d861679ca3f3d8"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codstts --version")

    testpath_dir = testpath/"test_project"
    mkdir_p testpath_dir

    (testpath_dir/"test.py").write <<~EOS
      def hello():
          print("Hello, World!")

      hello()
    EOS

    (testpath_dir/"test.js").write <<~EOS
      // JavaScript test file
      function greet() {
        console.log('Hello from JS');
      }

      greet();
    EOS

    output = shell_output("#{bin}/codstts #{testpath_dir}")
    assert_match "Python", output
    assert_match "JavaScript", output
  end
end
