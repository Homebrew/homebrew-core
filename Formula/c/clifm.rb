class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://github.com/leo-arch/clifm/archive/refs/tags/v1.20.tar.gz"
  sha256 "36f41d332985b9888a24a2ebb09ef837f40acea744b38498cd5e5313690ec10f"
  license "GPL-2.0-or-later"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "b4b1c5d192f9e2960d707df2a450feaf2cecc75a727bb76ef8e56382d96afdcc"
    sha256 arm64_ventura:  "192e658b10de85f240075094c396a8b2eec9d0dbcdcf88184795a40def5cee48"
    sha256 arm64_monterey: "64505fac0ad4c4a61e099d1509fa4245a02d9b39cb10266ffa442aed8afd1dd0"
    sha256 sonoma:         "977541924f0acbd08dee453c4a142a4b465b9e06c27002720dde1511f72fe2e3"
    sha256 ventura:        "64e063394e0a4c84bfef00564b004404815be32d91d9cfd8aa57e18ccb1fd407"
    sha256 monterey:       "531c14ec05ca856b362e9f78ce0601b1daaf618725a290bf75fe0882065eff5c"
    sha256 x86_64_linux:   "952ca3824865cf3240e85bef7c51a937c9d7240d77267fcd575de454e46bdf73"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: 'nonexist': No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end
