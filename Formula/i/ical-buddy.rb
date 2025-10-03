class IcalBuddy < Formula
  desc "Get events and tasks from the macOS calendar database"
  homepage "https://hasseg.org/icalBuddy/"
  url "https://github.com/dkaluta/icalBuddy64/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "aff42b809044efbf9a1f7df7598e9e110c1c4de0a4c27ddccde5ea325ddc4b77"
  license "MIT"
  revision 1
  head "https://github.com/dkaluta/icalBuddy64.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "681a0fc1f19e99c61a954df34f2a9b834afa0984587fe43fe3bfc0cc71ca0355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be7bf233e7a634c48779b5567de34e3f2a5af0e3b7b85fe1036cd899d665d1e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f5470ef901a02406a988f04542a69a7563b7936eaa90144aa316a10fcdc1977"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b5931088a2e5f1df062e44902d454d0c9bfeb466c6baf49ed06a946599f3c15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26aa750e17161ec7755b39cc6a8ae2cfc04cbfd0c1a2feec9db67fcb21c06fbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a04c344f77d1a6b2e137e0d7517b4d5bbe63f45079f3d1539138650af942936f"
    sha256 cellar: :any_skip_relocation, sonoma:         "643b31efdb5c6e5bc8338e397cc26ee9fdaebdde74e1f7835493c5065496993a"
    sha256 cellar: :any_skip_relocation, ventura:        "fa2359d74a4873041ef1774db5882be7468a4c056be5aca64ad01e3eaef604ff"
    sha256 cellar: :any_skip_relocation, monterey:       "7d0a5b87da06e38709f11885b3410c463260d753093f7525c8726b110b93aef8"
    sha256 cellar: :any_skip_relocation, big_sur:        "64163480c791a44e507091e8b73175f71aa3ce544d42fb1be7cc4f21f028fa55"
    sha256 cellar: :any_skip_relocation, catalina:       "64e1fd969d08e19aaf8a42d3fa5cb9d1a6f9eff77ef993d4e2d68eeed3e55230"
  end

  depends_on :macos

  def install
    inreplace "Makefile" do |s|
      # Allow native builds rather than only x86_64
      s.gsub! "-arch x86_64", ""

      # https://github.com/dkaluta/icalBuddy64/pull/5
      s.gsub! "-force_cpusubtype_ALL", ""

      # Keep the build date (used in manpages) reproducible
      s.change_make_var! "CURRDATE", time.strftime("%Y-%m-%d")
    end

    args = %W[
      icalBuddy
      icalBuddy.1
      icalBuddyLocalization.1
      icalBuddyConfig.1
      COMPILER=#{ENV.cc}
      APP_VERSION=#{version}
    ]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end

  test do
    # Testing of other calendar functionality requires granting calendar access
    # to the program (or the terminal emulator).
    assert_match "Non-lossy ASCII", shell_output("#{bin}/icalBuddy strEncodings")
  end
end
