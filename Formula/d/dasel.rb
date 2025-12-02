class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "ba8da9569f38e7f33453c03ac988382291a01004a96c307d52cccadb9ef7837e"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67ac40035b003307bfb9f4d59db4894475daf364f7e7f6baa9bcccd89f122ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda15f41f7ba3f9dcf3b59430a7f807f1f4685a994868364fbf25aa1c470fba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda15f41f7ba3f9dcf3b59430a7f807f1f4685a994868364fbf25aa1c470fba9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fda15f41f7ba3f9dcf3b59430a7f807f1f4685a994868364fbf25aa1c470fba9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bde39da341ff23150659a08e3514a08a6d1d71faf33ab2d6f53c94c93c18f68"
    sha256 cellar: :any_skip_relocation, ventura:       "3bde39da341ff23150659a08e3514a08a6d1d71faf33ab2d6f53c94c93c18f68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f3b14cee8db40c659ed7745967c0df0bdc30ea978bfccc4fec3bd102aec8714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b557e95eb7bb0822d238132e746fdc26245dcfeccbad94a007722ed8a7805d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v2/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
