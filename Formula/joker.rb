class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a963d8a3f1361143e33e0fa2463650173095cbf2e4593463007f32f4a81d3e57"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78db2f172c3be5c8e5f4064064d7ba5af424ceb774ccf9a33fa18244c66c06cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ffbe9fd80ff1f0cd2ec1957e26d71b4743d49b49b45f4f00444a4bef5141863"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ee09baccac49fd5580d178fa766dd1132c4168461001b1bacca66b223070910"
    sha256 cellar: :any_skip_relocation, ventura:        "ce4438952eb98d70acfd3344cee74f1514387ea09f5d75a152f8d728eeda56f6"
    sha256 cellar: :any_skip_relocation, monterey:       "f761309ac5ac79ee9dc2ea176869e76c968e8f3ef35f057d2d11c041d313d89c"
    sha256 cellar: :any_skip_relocation, big_sur:        "033facd463c6e3a686cc30442c8f00fe1c791472c7f44db009d2b3b2302fd57e"
    sha256 cellar: :any_skip_relocation, catalina:       "4ce83961819e735ee331d1a89777f31827082a5f8f02c564bcf9d60877c12003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb374d1deb58702ae57d049f1400d4d041d1b72be4f07674d1ba6bf3c9b1907"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath/"test.clj"
    test_file.write <<~EOS
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    EOS

    system bin/"joker", "--format", test_file
    output = shell_output("#{bin}/joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}/joker -v 2>&1")
  end
end
