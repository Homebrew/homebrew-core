class Libmusicbrainz < Formula
  desc "MusicBrainz Client Library"
  homepage "https://musicbrainz.org/doc/libmusicbrainz"
  url "https://github.com/metabrainz/libmusicbrainz/releases/download/release-5.1.0/libmusicbrainz-5.1.0.tar.gz"
  sha256 "6749259e89bbb273f3f5ad7acdffb7c47a2cf8fcaeab4c4695484cef5f4c6b46"
  license "LGPL-2.1-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bedefe5a0086b73a7ccfa342df5af7238cdd9851d541d19b6069549098f507d2"
    sha256 cellar: :any,                 arm64_sequoia: "c8db1669bb8869f5812eb0d46e9a84dce7ec3370bcb5405d9071612c5bdd4ec2"
    sha256 cellar: :any,                 arm64_sonoma:  "eb4bb010621dd980551a251a05e00645cde63db709efa377ccb967b6c162d9db"
    sha256 cellar: :any,                 sonoma:        "b424ac7a62a339cf9c1c1e63f60624fd5294329ae6ca3bd259f30bf53893cafc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f01561b97020929208e94416f0b01b62e5524d577429ea2a6ef1279ed81cd8a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d3ffdc6b8d4cd953ca8635cf70224441987b26484725fd1339da7ef3fb2c678"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "neon"

  uses_from_macos "libxml2"

  # Backport fix to build with newer libxml2
  patch do
    url "https://github.com/metabrainz/libmusicbrainz/commit/4655b571a70d73d41467091f59c518517c956198.patch?full_index=1"
    sha256 "ee0c63e56a17156bca13b157744a54aeed6e19b39f65b14f2a5ac4e504358c8e"
  end

  # cmake: Set minimum required version to 3.5 for CMake 4+
  patch do
    url "https://github.com/metabrainz/libmusicbrainz/commit/9d216e08aadf436dd166876d566efe033510adc6.patch?full_index=1"
    sha256 "2074078fabd6920ec085df06d1fd28a3eced86176788e17f3ea67a1d40d1189d"
  end

  def install
    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end
end
