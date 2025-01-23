class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.18.1/fswatch-1.18.1.tar.gz"
  sha256 "199609ca2aeb3aa7dc07980c616527805d0c5d017945fe7a81ef8d609104e2aa"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "53bb4f48e08d8fd3b2f14f8e0ed1ed0992f9dffe1815a9268435419f30167f72"
    sha256 cellar: :any, arm64_sonoma:  "72e76d4a81b4ff3e7f6f638a9ce0a36f20f568340253eb64c3fcaab1bf53050d"
    sha256 cellar: :any, arm64_ventura: "a94ec0f8aed86c9e497531fab752cd0e00284bd0a0d837359944b706680bbd60"
    sha256 cellar: :any, sonoma:        "bb6238c83fb5a73d08f51a3a0d9dc08c91035fc04a52716884bd8a3f57ac73c9"
    sha256 cellar: :any, ventura:       "0c70ea700fb553324cd1498552c4e735d6b3e614d2c829b2fbc542972f552abf"
    sha256               x86_64_linux:  "37451a08d50b33275ef47bd0530e364af37777364df9783b3b3f6698c3996b7c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
