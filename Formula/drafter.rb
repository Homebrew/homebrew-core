class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v4.0.2/drafter-4.0.2.tar.gz"
  sha256 "35e9ca58acbf7dc2e8c48a8bf16bc7a4efbdc2dedaeedb258e0ad80c14496d78"
  head "https://github.com/apiaryio/drafter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2a5b57cc3e10cc9365bd04bd6b1ec00037b0b97a982101f6c40f4c280558ea3" => :catalina
    sha256 "b5ee20160ca4d4721d493ff18f49a930acb508a877146ade6a391f7bd831ac4f" => :mojave
    sha256 "8220d968afb0a0cdfc25aa51b8547b246e138018501e7e80b50864fa92ff7da0" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "drafter", "drafter-cli"
    system "make", "install"
  end

  test do
    (testpath/"api.apib").write <<~EOS
      # Homebrew API [/brew]

      ## Retrieve All Formula [GET /Formula]
      + Response 200 (application/json)
        + Attributes (array)
    EOS
    assert_equal "OK.", shell_output("#{bin}/drafter -l api.apib 2>&1").strip
  end
end
