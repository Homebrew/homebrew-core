class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.26.0.tar.gz"
  sha256 "d3c3884b314dae48a6884e919d0a12acac5aea95d970544e4632a1773857d19b"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    strategy :json do |json|
      json["releases"]&.map do |release|
        next if release["beta"] || release["debug"]

        release["version"]
      end
    end
  end

  bottle do
    sha256 arm64_sequoia: "51f499240230fc071b43493aa72cdac33aa55b7aa49222fa93dab9962a4e7259"
    sha256 arm64_sonoma:  "096ddf9dd1540b96e9d6b6e66ea17775ac8a592fb00a69039778600dc14e0424"
    sha256 arm64_ventura: "71439dc718bd1f1d9ebbdc5a06273c923ef4681292a8a930278226d46850d535"
    sha256 sonoma:        "9ac7d8f3466920e0fde4efcea9b193f154938d97ea54d2d1e8800a06d7de5779"
    sha256 ventura:       "055717afdc6d0b9a07be143b0231de307e70cbf96296838abb55006e336de6d1"
    sha256 arm64_linux:   "dfb03291570f5ace211e4a2eff2d51803bd3e58575cac4fff641496c7ca334f1"
    sha256 x86_64_linux:  "319184eb2a6a3dd75f182ce3a655b8cbe3e006fedd7c592702cbb7c265d14cde"
  end

  depends_on "librsync"
  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "curl", since: :ventura # uses CURLOPT_PROTOCOLS_STR, available since curl 7.85.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.26.0.tar.gz"
    sha256 "fc8b0ad20e803e0d1e9dcda7afb2f3f5110357ac0e553ed95cf2cbea9652451d"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "masterfiles resource needs to be updated" if version != resource("masterfiles").version

    args = %W[
      --with-workdir=#{var}/cfengine
      --with-lmdb=#{Formula["lmdb"].opt_prefix}
      --with-pcre2=#{Formula["pcre2"].opt_prefix}
      --without-mysql
      --without-postgresql
    ]

    args << "--with-systemd-service=no" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  def post_install
    workdir = var/"cfengine"
    secure_dirs = %W[
      #{workdir}/inputs
      #{workdir}/outputs
      #{workdir}/ppkeys
      #{workdir}/plugins
    ]
    chmod 0700, secure_dirs
    chmod 0750, workdir/"state"
    chmod 0755, workdir/"modules"
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
