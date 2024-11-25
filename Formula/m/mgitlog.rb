class Mgitlog < Formula
  desc "Generate beautiful, readable work logs from git commits across multiple repos"
  homepage "https://github.com/thomasklein/mgitlog"
  url "https://github.com/thomasklein/mgitlog/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "bfc02701cb09673a7c062d2e93c1536447ad5f264f8a4ccdc3894ee5a8014f39"
  license "MIT"

  depends_on "git" => :test

  def install
    bin.install "mgitlog.sh" => "mgitlog"
  end

  test do
    # Test version output
    assert_match "1.0.0", shell_output("#{bin}/mgitlog --version").strip

    # Test help output
    assert_match "Usage:", shell_output("#{bin}/mgitlog --help")

    # Create a test git repository with explicit main branch
    system "git", "init", "-b", "main"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test User"
    (testpath/"test.txt").write "Test file"
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"

    # Test basic execution with today's date
    output = shell_output("#{bin}/mgitlog -d today")
    assert_match "Git logs for", output
    assert_match "test@example.com", output

    # Test JSON output
    json_output = shell_output("#{bin}/mgitlog --json -d today")
    assert_match "\"date_range\":", json_output
    assert_match "\"repositories\":", json_output
    assert_match "\"commits\":", json_output
  end
end
