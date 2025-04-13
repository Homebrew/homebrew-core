class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/refs/tags/1.3.2.tar.gz"
  sha256 "df034c676b512081f92727f4f36ad38e4d5d91d20a4a9abd52f10885b6c475e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "68dca765189cde9bb909b876cb833c3fe9f0e6cd98c7dddf470511374a4b1900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63b05c840d8e8778e8852c48c86f9d016a5836d166be5ea1e903139447df6e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e4451744e95c6dd7b59d3fb4f87ca0544b6490b612f0f1a7bf89239d7cbbfc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "719c4b5fbdf147b90f9bf5e66852aae45ee16dfbf6a98d88965b1e811382ed8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "347ff9994e2283642d8c4e872befd1b05498730239954374a264ef9541608280"
    sha256 cellar: :any_skip_relocation, sonoma:         "19581e7d7ab4ddc9da2e82d307e19ac191b82fee6152bfd9c14605b29559465b"
    sha256 cellar: :any_skip_relocation, ventura:        "2bfcd4960b00c49f40191b1223bafe95cecb6e97a9b85de96980efffc32f1309"
    sha256 cellar: :any_skip_relocation, monterey:       "99b257d8a7e4b36c4595c7254450ead9356ac66540179d4339334ad1ecf7693c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae2efc4c958a8eab84e0c2009720ace1c8862d46e26bbf10fc79b3908b3ae5e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "11cb695074fd290b7e8cde5ab31824468a1193a4cea9b6ec28e1440878437ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd6ad4105c7f8e55381dbd107a613b9ef790e39c4b14b35bd97808fb14cddaaf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxslt"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
