class Base16384 < Formula
  desc "Encode binary files to printable utf16be"
  homepage "https://github.com/fumiama/base16384"
  url "https://github.com/fumiama/base16384/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "3b612e8ab32e7b108a08cdf4112a04fbebaaa572bc60d386343a954c695e450b"
  license "GPL-3.0-or-later"
  head "https://github.com/fumiama/base16384.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1f5f8def255ca57e635603ef572bb652a7920bae85be2e2c84a13c446d6d4615"
    sha256 cellar: :any,                 arm64_sequoia: "deeb2188d7479f513249484059fd1de2adbeeecc433b5017bd352ca29328d9c4"
    sha256 cellar: :any,                 arm64_sonoma:  "7908aa72a066df28976ac2c33318b3bc14dcdcdb14e03f075aaef4e49f927b0d"
    sha256 cellar: :any,                 sonoma:        "b9c40a9eeae7fb639505085bf436817583a4bef68ab415966a232facbb1634b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "292b2d8e8b87a90ee2dbb426a69ed69f8c58945cda95c879478eeab33d38c818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3010ed072ea82794a4f40a0ec7a11e2bc51a6f0a8d25aa18483be84976b9a2b3"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    hash = pipe_output("#{bin}/base16384 -e - -", "1234567890abcdefg", 0)
    assert_match "1234567890abcdefg", pipe_output("#{bin}/base16384 -d - -", hash, 0)
  end
end
