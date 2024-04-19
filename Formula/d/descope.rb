class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "c163a809f11ddb160b9b2b9215e4fa594d9c8fded6f2dce2710631fce46af523"
  license "MIT"

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "descope"
    generate_completions_from_executable(bin/"descope", "completion")
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit 2>&1")
    assert_match "managing projects", shell_output("#{bin}/descope project 2>&1")
  end
end
