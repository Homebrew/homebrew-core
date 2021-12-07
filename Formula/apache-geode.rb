class ApacheGeode < Formula
  desc "In-memory Data Grid for fast transactional data processing"
  homepage "https://geode.apache.org/"
  url "https://dlcdn.apache.org/geode/1.14.0/apache-geode-1.14.0-src.tgz"
  sha256 "bc5f55dbafaa1a48913c6bcc9a3a0a1051967ecabc779eded6b2d6da56cb53af"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "219e2500b68c58788b63042b5d85c01bb766b39208f0848dcbb31bd6dcc72803"
  end

  depends_on "gradle" => :build
  # Could not find protoc-osx-aarch_64.exe (com.google.protobuf:protoc:3.11.4).
  # https://github.com/grpc/grpc-java/issues/7690
  depends_on arch: :x86_64
  depends_on "openjdk@11"

  def install
    system "./gradlew", "build", "--stacktrace"
  end

  test do
    flags = "--dir #{testpath} --name=geode_locator_brew_test"
    output = shell_output("#{bin}/gfsh start locator #{flags}")
    assert_match "Cluster configuration service is up and running", output
  ensure
    quiet_system "pkill", "-9", "-f", "geode_locator_brew_test"
  end
end
