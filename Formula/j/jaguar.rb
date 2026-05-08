class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.64.0.tar.gz"
  sha256 "159e4be1d5e44558236d89b0966b455a24c9ba82889e557f1e590ba713670acc"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12f4ae01f3deb480a5c081d589a3370ff5a913ab24782445efcda673786efcea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12f4ae01f3deb480a5c081d589a3370ff5a913ab24782445efcda673786efcea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f4ae01f3deb480a5c081d589a3370ff5a913ab24782445efcda673786efcea"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9606d6a460918e55a0c31fd2ce4ba08c32b0d0a55bd35c6d59045680816c1dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db94b074f0b110b1deace0cdb1aaff0769803fd98c8db07a0a76f63202fdcffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f24189df216f08656011ad760e0f81055a1b992a46fc50ad4fceeb7460b292"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:\t v#{version}", shell_output("#{bin}/jag --no-analytics version 2>&1")

    (testpath/"hello.toit").write <<~TOIT
      main:
        print "Hello, world!"
    TOIT

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output("#{bin}/jag run #{testpath}/hello.toit 2>&1", 1)
  end
end
