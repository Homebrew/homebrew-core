class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.0.0.tar.gz"
  sha256 "14c88c759cfb5212e656dab66fb2ec9ed1e835627e555cdf76838bb4bde062b2"

  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d05884cfafc005100ece69982f884199e945fbc891fbca7affe91ddb1c7368b" => :high_sierra
    sha256 "5b56d25e1844ad13f35464cacc27db4a885e3df4dddefe5ca20d579bd14fb91f" => :sierra
    sha256 "b6899315d289420c94305bbc60bf236d5b8a877e147645d51c1aebde3f9dec98" => :el_capitan
    sha256 "ad5d8d0d865f9d369090698432c822c7842a4b59d8c5bc1627cd54959cb3329c" => :yosemite
  end

  depends_on :xcode => :build

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/blueutil"
  end

  test do
    system "#{bin}/blueutil"
  end
end
