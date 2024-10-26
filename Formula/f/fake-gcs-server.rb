class FakeGcsServer < Formula
  desc "Google Cloud Storage emulator & testing library"
  homepage "https://pkg.go.dev/github.com/fsouza/fake-gcs-server/fakestorage?tab=doc"
  url "https://github.com/fsouza/fake-gcs-server/archive/refs/tags/v1.50.2.tar.gz"
  sha256 "1607904cb3eb178575c0fdcb6b76f31f0fab21205a464c478625c90e28cf824b"
  license "BSD-2-Clause"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Usage of fake-gcs-server", shell_output("#{bin}/fake-gcs-server -h 2>&1").strip
  end
end
