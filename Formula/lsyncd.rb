class Lsyncd < Formula
  desc "Synchronize local directories with remote targets"
  homepage "https://github.com/lsyncd/lsyncd"
  url "https://github.com/lsyncd/lsyncd/archive/release-2.2.3.tar.gz"
  sha256 "7bcd0f4ae126040bb078c482ff856c87e61c22472c23fa3071798dcb1dc388dd"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "426dd58ae80fc69dee4b34367ade886d432c238d1a93b98d86dd50a081833375"
    sha256 cellar: :any, arm64_big_sur:  "2351ed804db55c557bbd623de74d8da034bc97ab1174edc361e3b735586e8b3b"
    sha256 cellar: :any, monterey:       "0962fcbdf87bfa07927a1436986d34ad7473a114df6e2c5f9aac2acdbea94054"
    sha256 cellar: :any, big_sur:        "5551d7d77b7fca7fe4a6193d924c3a04e5940856a837d108c9212951b65c3980"
    sha256 cellar: :any, catalina:       "e25b5027f2f2d0776ad8df8b1f3cc788167234263bac8843ed3fd18f3222fd0a"
    sha256 cellar: :any, mojave:         "5dbf799c6709769315f3d495e4a7e3a6988e64c00c2d69dd4d3e774879d8b5f3"
  end

  depends_on "cmake" => :build
  depends_on "lua"

  on_macos do
    xnu_headers = {
      "10.10"   => ["xnu-2782.1.97.tar.gz",       "612a0eb12d2b2fad3b2df33224abd1c65b89f1c95cd1cea6853694840d48d322"],
      "10.10.1" => ["xnu-2782.1.97.tar.gz",       "612a0eb12d2b2fad3b2df33224abd1c65b89f1c95cd1cea6853694840d48d322"],
      "10.10.2" => ["xnu-2782.10.72.tar.gz",      "2fc7d3a1bc03c3ce2f2c845d652338b02cf088fe7815926d5e0c1a57b0c2e5c9"],
      "10.10.3" => ["xnu-2782.20.48.tar.gz",      "8b502e0c6bcec462e9b7a6d51323ee71215b6efc423e50303c8238218fc6ccc0"],
      "10.10.4" => ["xnu-2782.30.5.tar.gz",       "66d57f67d2b0118c4e6d69a1fed2911f959c7834a1bae0d89dce23f6f732b110"],
      "10.10.5" => ["xnu-2782.40.9.tar.gz",       "059ac030b49e27447a207693665d017ad389a077f6465520a68381472e050b48"],
      "10.11"   => ["xnu-3247.1.106.tar.gz",      "09543a29dc06ef9a97176a6e2dbdad868bc0113d3b57f2b28b5d08af897c577d"],
      "10.11.1" => ["xnu-3247.10.11.tar.gz",      "76f215372d0b4fb8397599c5b7a5a97c777aca553a4aea5f0f9f6cbcb50147f1"],
      "10.11.2" => ["xnu-3248.20.55.tar.gz",      "cdeb243540d5d13c9bee6234d43cd6eafced16e4cdc458fb0bf98921e5dd54a9"],
      "10.11.3" => ["xnu-3248.30.4.tar.gz",       "2284f195285d743a8f240245cbffa15856567e570d1ea904aa9cc02bba3d1d92"],
      "10.11.4" => ["xnu-3248.40.184.tar.gz",     "692a30c1290bd46396d4a68dd9ba39c348f46afa211675b30fa2f33cf8a6ac13"],
      "10.11.5" => ["xnu-3248.50.21.tar.gz",      "2d8bcce595764944670d4f0a3d5cf8a30f3ca6af5c0977f550cdf77438625334"],
      "10.11.6" => ["xnu-3248.60.10.tar.gz",      "a4f646c6d34814df5a729a2c0b380c541dd5282b5d82e35e31bf66c034c2b761"],
      "10.12"   => ["xnu-3789.1.32.tar.gz",       "a893862ad57965368da8ef65157df369d9710a0aa0fc4e6347855efca18a9560"],
      "10.12.1" => ["xnu-3789.21.4.tar.gz",       "51e4b1c5b8868da2f93878872144e76f8be13eb273af296eb91af3c0574c1add"],
      "10.12.2" => ["xnu-3789.31.2.tar.gz",       "61d61518894111cd24860b814f3c7359150e828c27897cd2cff3f744ad7007f7"],
      "10.12.3" => ["xnu-3789.41.3.tar.gz",       "28fe6f8411b5b7663c684c825e3525ef8efcda2ba72e1c2a94ad5e77ce2f919a"],
      "10.12.4" => ["xnu-3789.51.2.tar.gz",       "f43feaa246d33874d617896ba1214adc2d11c784b537b6c2f89939451ea9ba23"],
      "10.12.5" => ["xnu-3789.60.24.tar.gz",      "73876f2f3b132d71100f6f0c1675401ac234eca6929c1aea9032a55f27b95bad"],
      "10.12.6" => ["xnu-3789.70.16.tar.gz",      "0bc4cf425513dd16f3032f189d93cdb6bef48696951bd2e5bf4878dacdcd10d2"],
      "10.13"   => ["xnu-4570.1.46.tar.gz",       "0a8c1608b79aa2384ce17ed91ce2327e56367ac7588d51260e535eb6ce94d6e3"],
      "10.13.1" => ["xnu-4570.20.62.tar.gz",      "914b8d84cae145cee4687144e787c841034521eb71274d491e0469ee96aaf6f8"],
      "10.13.2" => ["xnu-4570.31.3.tar.gz",       "00950fe7da6b1157f33d0030ffc216409a187a471851493300eefb28c535649a"],
      "10.13.3" => ["xnu-4570.41.2.tar.gz",       "daea3a3c935d55ca798cfb488379d312e0fa1bcb2fe61b36059ca8c094bd2ddb"],
      "10.13.4" => ["xnu-4570.51.1.tar.gz",       "2a8ac1074b40593786dac7d6b3de227a04e2d34721b570e552e11adbaad49d2d"],
      "10.13.5" => ["xnu-4570.61.1.tar.gz",       "7b040e6441e781027608c12c3e4236a4bd34a6142981f237a07e8e03d7c82c8b"],
      "10.13.6" => ["xnu-4570.71.2.tar.gz",       "b9e2c84c3ee62819917d3bc845e10c2f4bde1194e731c192b6cf0239da5a5a14"],
      "10.14"   => ["xnu-4903.221.2.tar.gz",      "81f91ab3c9b807044bc887ba253ebfa8793ab7b44e0441104bbc9fd9e72582c9"],
      "10.14.1" => ["xnu-4903.221.2.tar.gz",      "81f91ab3c9b807044bc887ba253ebfa8793ab7b44e0441104bbc9fd9e72582c9"],
      "10.14.2" => ["xnu-4903.231.4.tar.gz",      "fb749b4e4ba79c8a3b69522746719ce0ecb4fe96c7877b679fc7dbbd5a10bfe2"],
      "10.14.3" => ["xnu-4903.241.1.tar.gz",      "56c630c7ce00170740ec002c84b8ac226d19fe7b30daad9b0cbc9a7d7ca14f46"],
      "10.14.4" => ["xnu-4903.241.1.tar.gz",      "56c630c7ce00170740ec002c84b8ac226d19fe7b30daad9b0cbc9a7d7ca14f46"],
      "10.14.5" => ["xnu-4903.241.1.tar.gz",      "56c630c7ce00170740ec002c84b8ac226d19fe7b30daad9b0cbc9a7d7ca14f46"],
      "10.14.6" => ["xnu-4903.270.47.tar.gz",     "099c1c50c4cef4db5fcf4df6a6314498693ad52ed5e813201e2cf442e22985fe"],
      "10.15"   => ["xnu-6153.11.26.tar.gz",      "de302aa011c207e36d19fdb1065922fc7e8e2067b3ebe693446a098e43208d94"],
      "10.15.1" => ["xnu-6153.41.3.tar.gz",       "dcd6102e91ec0e2cbedfbe3555fff76aff67542f691366db81582e5b91d54b69"],
      "10.15.2" => ["xnu-6153.61.1.tar.gz",       "f27d957c95863b0c80efad68def610894c8f39a24f86a4440d89ccb1b43e9bff"],
      "10.15.3" => ["xnu-6153.81.5.tar.gz",       "e1d39b1528aa1b6e072aad778dd331beb0e781c3ca910dc0588d8c65fc60efa1"],
      "10.15.4" => ["xnu-6153.101.6.tar.gz",      "8bf25b4022831e33a6f8e42c14017613bc0c29bac8f8352b7d8eba0b910c0a18"],
      "10.15.5" => ["xnu-6153.121.1.tar.gz",      "3a8c04e1304fd77611fc9fbf44da9dd01d2256c61d04dff6fd12e0259742db09"],
      "10.15.6" => ["xnu-6153.141.1.tar.gz",      "886388632a7cc1e482a4ca4921db3c80344792e7255258461118652e8c632d34"],
      "10.15.7" => ["xnu-6153.141.1.tar.gz",      "886388632a7cc1e482a4ca4921db3c80344792e7255258461118652e8c632d34"],
      "11.0"    => ["xnu-7195.50.7.100.1.tar.gz", "f4467a8a6122af27d5e5dd5e4f743159e7a07255992fda81328ce510f8adf287"],
      "11.1"    => ["xnu-7195.60.75.tar.gz",      "d6f675947e620deaf41056ac4b6ce843f4e2cac46344efe0afecfadf52c522ec"],
      "11.2"    => ["xnu-7195.81.3.tar.gz",       "09c4180b0980b1a9c62e4c37a36e97487cf8cc03767ccb8e4fdb9c7ae38782a5"],
      "11.3"    => ["xnu-7195.101.1.tar.gz",      "897ba193f850404262d08dee7ec139302eb42485d20a88badf9665c9b562310b"],
      "11.4"    => ["xnu-7195.121.3.tar.gz",      "f02ea4f4e1c36a7ac89248b80d67a2739c45d4f795a10aace09d78e545653385"],
      "11.5"    => ["xnu-7195.141.2.tar.gz",      "ec5aa94ebbe09afa6a62d8beb8d15e4e9dd8eb0a7e7e82c8b8cf9ca427004b6d"],
      "11.6"    => ["xnu-7195.141.2.tar.gz",      "ec5aa94ebbe09afa6a62d8beb8d15e4e9dd8eb0a7e7e82c8b8cf9ca427004b6d"],
      "12.0"    => ["xnu-8019.41.5.tar.gz",       "54540440f73d5dcfe94ed33591f2fa40609f932213a5e6862268589d32ff7ac4"],
      "12.1"    => ["xnu-8019.61.5.tar.gz",       "1e035fcf9a2b86dfadcccbbaf963f98b878772ae29c5058f1dc0e5852f70650e"],
      "12.2"    => ["xnu-8019.80.24.tar.gz",      "2fbfe90ec8c93d93f0dd69f09610011d26a722f98266202de6a7c2af764712b4"],
    }

    macos_version = if MacOS.version >= :big_sur
      MacOS.full_version.major_minor # Ignore bugfix/security updates
    else
      MacOS.full_version
    end
    tarball, checksum = if xnu_headers.key? macos_version
      xnu_headers.fetch(macos_version)
    else
      xnu_headers.values.last # Fallback
    end
    resource "xnu" do
      url "https://github.com/apple-oss-distributions/xnu/archive/refs/tags/#{tarball}"
      sha256 checksum
    end
  end

  # Fix issues with 10.15+ volume layout.
  # Remove with the next release.
  patch do
    url "https://github.com/lsyncd/lsyncd/commit/7bb8715bfd425621a57068e39fac37bac3456318.patch?full_index=1"
    sha256 "578278ca7a1f2e23a53da207daeb58bc946e2fe03751b8e2990af008f580c3da"
  end

  # Fix finding of unversioned Lua.
  # Remove with the next release.
  patch do
    url "https://github.com/lsyncd/lsyncd/commit/0af99d8d5ba35118e8799684a2d4a8ea4b0c6957.patch?full_index=1"
    sha256 "a4f9eba3246c611febec68a0599935fa5ec0e4ad16a165ae19cd634afea45523"
  end

  # Fix compile with Lua 5.4.
  # Remove with the next release.
  patch do
    url "https://github.com/lsyncd/lsyncd/commit/a609f34971955450c90db246e992c511cc933d5e.patch?full_index=1"
    sha256 "69d32ae25704523e11c0774983f43bdadf1d7d22bb693eb18b62523bc716c9c4"
  end

  def install
    # Fix manpage install location.
    # https://github.com/lsyncd/lsyncd/commit/a410ddebb88bdc346476e80b3e50f5d2e35b4e41
    # Remove with the next release.
    inreplace "CMakeLists.txt", "DESTINATION man", "DESTINATION share/man/man1 COMPONENT man"

    args = []
    if OS.mac?
      resource("xnu").stage buildpath/"xnu"
      args += %W[-DWITH_INOTIFY=OFF -DWITH_FSEVENTS=ON -DXNU_DIR=#{buildpath}/xnu]
    else
      args += %w[-DWITH_INOTIFY=ON -DWITH_FSEVENTS=OFF]
    end
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"lsyncd", "--version"
  end
end
