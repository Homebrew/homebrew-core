class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://masterpassword.app/"
  url "https://masterpassword.app/mpw-2.7-cli-1-0-gd5959582.tar.gz"
  version "2.7-cli-1"
  sha256 "480206dfaad5d5a7d71fba235f1f3d9041e70b02a8c1d3dda8ecba1da39d3e96"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/MasterPassword/MasterPassword.git"

  # The first-party site doesn't seem to list version information, so it's
  # necessary to check the tags from the `head` repository instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+[._-]cli[._-]?\d+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "252fbad588409e4fd5be091f7c248150e75b995d39ce334938b9a7d33534cbc9"
    sha256 cellar: :any, big_sur:       "4ae85b3d30e47294436b7fddca456c98ed2bf546793f2ef9d57a372d782fb072"
    sha256 cellar: :any, catalina:      "2f275d762a9c73bd6b3f2e5a7f3f13a9c99ddfc3e2f89a2ededa07ba89b6de40"
    sha256 cellar: :any, mojave:        "9103716223529cd3e2cb969e904892bf2022cb8e73918418f2d3d343d1325c80"
    sha256 cellar: :any, high_sierra:   "07b89df8d96f9c1cebbf6296a4e98b2bac833c45f736b646a1eba24bd5244732"
  end

  depends_on "jq" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "ncurses"

  def install
    cd "cli" unless build.head?
    cd "platform-independent/c/cli" if build.head?

    ENV["targets"] = "mpw"
    ENV["mpw_json"] = "1"
    ENV["mpw_color"] = "1"

    system "./build"
    bin.install "mpw"
  end

  test do
    ##  V3
    assert_equal "CefoTiciJuba7@",
      shell_output("#{bin}/mpw -Fnone -q -u 'test' -M 'test'             " \
                   "                                           'test'").strip
    assert_equal "Tina0#NotaMahu",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest'             " \
                   "                                           'ẗesẗ'").strip
    assert_equal "Tina0#NotaMahu",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest'             " \
                   "                            -C ''          'ẗesẗ'").strip
    assert_equal "Tina0#NotaMahu",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest'             " \
                   "        -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Tina0#NotaMahu",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest'             " \
                   "  -a3   -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Tina0#NotaMahu",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest'             " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Tina0#NotaMahu",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "KovxFipe5:Zatu",
      shell_output("#{bin}/mpw -Fnone -q -u '⛄'   -M 'ẗest' -tlong       " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "ModoLalhRapo6#",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M '⛄'   -tlong       " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "CudmTecuPune7:",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c1 -a3 -p 'authentication' -C ''          '⛄'").strip
    assert_equal "yubfalago",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest'             " \
                   "        -p 'identification' -C ''          'ẗesẗ'").strip
    assert_equal "yubfalago",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tname      " \
                   "-c1 -a3 -p 'identification' -C ''          'ẗesẗ'").strip
    assert_equal "jip nodwoqude dizo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest'             " \
                   "        -p 'recovery'       -C ''          'ẗesẗ'").strip
    assert_equal "jip nodwoqude dizo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a3 -p 'recovery'       -C ''          'ẗesẗ'").strip
    assert_equal "dok sorkicoyu ruya",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a3 -p 'recovery'       -C 'quesẗion'  'ẗesẗ'").strip
    assert_equal "j5TJ%G0WWwSMvYb)hr4)",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tmax       " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "TinRaz2?",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tmed       " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "jad0IQA3",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tbasic     " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Tin0",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tshort     " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "1710",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tpin       " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "tinraziqu",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tname      " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "tinr ziq taghuye zuj",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a3 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "HidiLonoFopt9&",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c4294967295 -a3 -p 'authentication' -C '' 'ẗesẗ'").strip

    ##  V2
    assert_equal "CefoTiciJuba7@",
      shell_output("#{bin}/mpw -Fnone -q -u 'test' -M 'test' -tlong      " \
                   "-c1 -a2 -p 'authentication' -C ''          'test'").strip
    assert_equal "HuczFina3'Qatf",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "SicrJuwaWaql0#",
      shell_output("#{bin}/mpw -Fnone -q -u '⛄'   -M 'ẗest' -tlong       " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "LokaJayp1@Faba",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M '⛄'   -tlong       " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "DoqaHulu8:Funh",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c1 -a2 -p 'authentication' -C ''          '⛄'").strip
    assert_equal "yiyguxoxe",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tname      " \
                   "-c1 -a2 -p 'identification' -C ''          'ẗesẗ'").strip
    assert_equal "vu yelyo bat kujavmu",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a2 -p 'recovery'       -C ''          'ẗesẗ'").strip
    assert_equal "ka deqce xad vomacgi",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a2 -p 'recovery'       -C 'quesẗion'  'ẗesẗ'").strip
    assert_equal "wRF$LmB@umWGLWeVlB0-",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tmax       " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "HucZuk0!",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tmed       " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "wb59VoB5",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tbasic     " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Huc9",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tshort     " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "2959",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tpin       " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "huczukamo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tname      " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "huc finmokozi fota",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a2 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Mixa1~BulgNijo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c4294967295 -a2 -p 'authentication' -C '' 'ẗesẗ'").strip

    ##  V1
    assert_equal "CefoTiciJuba7@",
      shell_output("#{bin}/mpw -Fnone -q -u 'test' -M 'test' -tlong      " \
                   "-c1 -a1 -p 'authentication' -C ''          'test'").strip
    assert_equal "SuxiHoteCuwe3/",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "CupaTixu8:Hetu",
      shell_output("#{bin}/mpw -Fnone -q -u '⛄'   -M 'ẗest' -tlong       " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "NaqmBanu9+Decs",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M '⛄'   -tlong       " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "XowaDokoGeyu2)",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c1 -a1 -p 'authentication' -C ''          '⛄'").strip
    assert_equal "makmabivo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tname      " \
                   "-c1 -a1 -p 'identification' -C ''          'ẗesẗ'").strip
    assert_equal "je mutbo buf puhiywo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a1 -p 'recovery'       -C ''          'ẗesẗ'").strip
    assert_equal "ne hapfa dax qamayqo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a1 -p 'recovery'       -C 'quesẗion'  'ẗesẗ'").strip
    assert_equal "JlZo&eLhqgoxqtJ!NC5/",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tmax       " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "SuxHot2*",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tmed       " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Jly28Veh",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tbasic     " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Sux2",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tshort     " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "4922",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tpin       " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "suxhotito",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tname      " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "su hotte pav calewxo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a1 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Luxn2#JapiXopa",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c4294967295 -a1 -p 'authentication' -C '' 'ẗesẗ'").strip

    ##  V0
    assert_equal "GeqoBigiFubh2!",
      shell_output("#{bin}/mpw -Fnone -q -u 'test' -M 'test' -tlong      " \
                   "-c1 -a0 -p 'authentication' -C ''          'test'").strip
    assert_equal "WumiZobxGuhe8]",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "KuhaXimj8@Zebu",
      shell_output("#{bin}/mpw -Fnone -q -u '⛄'   -M 'ẗest' -tlong       " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "CajtFayv9_Pego",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M '⛄'   -tlong       " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "QohaPokgYevu2!",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c1 -a0 -p 'authentication' -C ''          '⛄'").strip
    assert_equal "takxabico",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tname      " \
                   "-c1 -a0 -p 'identification' -C ''          'ẗesẗ'").strip
    assert_equal "je tuxfo fut huzivlo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a0 -p 'recovery'       -C ''          'ẗesẗ'").strip
    assert_equal "ye zahqa lam jatavmo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a0 -p 'recovery'       -C 'quesẗion'  'ẗesẗ'").strip
    assert_equal "g4@)4SlA#)cJ#ib)vvH3",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tmax       " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Wum7_Xix",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tmed       " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "gAo78ARD",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tbasic     " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Wum7",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tshort     " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "9427",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tpin       " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "wumdoxixo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tname      " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "wu doxbe hac kaselqo",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tphrase    " \
                   "-c1 -a0 -p 'authentication' -C ''          'ẗesẗ'").strip
    assert_equal "Pumy7.JadjQoda",
      shell_output("#{bin}/mpw -Fnone -q -u 'tesẗ' -M 'ẗest' -tlong      " \
                   "-c4294967295 -a0 -p 'authentication' -C '' 'ẗesẗ'").strip
  end
end
