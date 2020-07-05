class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20200705.2a7d4a2.tar.gz"
  version "20200705"
  sha256 "432dd9602df326088956b3e4f5efe656ad09777873d38695e0d68810899941c2"
  head "https://git.tartarus.org/simon/agedu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93e3e4722e8b4f3e7a28656bd779bd126377542d839f746816027a47073dc254" => :catalina
    sha256 "84b4caf41c37aec16cc884354491e1464c29e85b584d1555b26002b9cfa9897d" => :mojave
    sha256 "2a37fae4983a2a71ec1780eae4b0cd7f8367875e2078ff7fa0f5392125751b33" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "halibut" => :build

  def install
    system "./mkauto.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_predicate testpath/"agedu.dat", :exist?
  end
end
