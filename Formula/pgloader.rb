class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/archive/v3.4.1.tar.gz"
  sha256 "3ac4d03706057a35e1d4d0e63571b84be7d0d07ea09e015d90e242200488fe82"
  revision 1

  bottle do
    rebuild 1
    sha256 "f847576d5d4769b8021323c809b585057a1f99f4154116a6fa2f70abb34e5c6a" => :high_sierra
    sha256 "aef13aa237bdad345ec75dacf88fbaf555519c047ef2c42fd8bd6753c08c3db2" => :sierra
    sha256 "7fb6e58e1030e6dfd8a096525fab8ad65f739a16644f023b7c7cc6dfbc91c8ab" => :el_capitan
  end

  head do
    url "https://github.com/dimitri/pgloader.git"

    resource "cl-mustache" do
      url "https://beta.quicklisp.org/archive/cl-mustache/2015-09-23/cl-mustache-20150923-git.tgz"
      sha256 "22b0938a3765229a54bd84f70c7de2a56e8903fef4dbc987a3c8621314d800e4"
    end

    resource "yason" do
      url "https://beta.quicklisp.org/archive/yason/2016-02-08/yason-v0.7.6.tgz"
      sha256 "1332170b030067e2ea7119e8a18abb7778b89fd6a2163f808d80dbbd48b0ee01"
    end
  end

  depends_on "sbcl"
  depends_on "freetds"
  depends_on "buildapp" => :build
  depends_on "postgresql" => :recommended

  # Resource stanzas are generated automatically by quicklisp-roundup.
  # See: https://github.com/benesch/quicklisp-homebrew-roundup

  resource "alexandria" do
    url "https://beta.quicklisp.org/archive/alexandria/2017-08-30/alexandria-20170830-git.tgz"
    sha256 "894e54f77594b13137b5b8ec05937ad6b78bc15c4630ffd1e550e1f226a2f96e"
  end

  resource "anaphora" do
    url "https://beta.quicklisp.org/archive/anaphora/2017-02-27/anaphora-20170227-git.tgz"
    sha256 "a9790080e92f451e4bd43ccd8accf69d1e0f2089e0de207bf4271b4fd932dbc6"
  end

  resource "asdf-finalizers" do
    url "https://beta.quicklisp.org/archive/asdf-finalizers/2017-04-03/asdf-finalizers-20170403-git.tgz"
    sha256 "b22f0fa44b662abdab5e844b03cd104f1c391234ad3d7bd4928bc521025053f0"
  end

  resource "asdf-system-connections" do
    url "https://beta.quicklisp.org/archive/asdf-system-connections/2017-01-24/asdf-system-connections-20170124-git.tgz"
    sha256 "f8723e0b0b8bd5f964f7726536e52aacb2e9833d475fcde8333cda81d7190241"
  end

  resource "babel" do
    url "https://beta.quicklisp.org/archive/babel/2017-12-27/babel-20171227-git.tgz"
    sha256 "2e0b1e1513d2cf61f23f38f4d2b5fec23efecf88cb72b68aff7d07559334de98"
  end

  resource "bordeaux-threads" do
    url "https://beta.quicklisp.org/archive/bordeaux-threads/2016-03-18/bordeaux-threads-v0.8.5.tgz"
    sha256 "edaedd450d9267b0a578c9da421fdc96e5f93b119d1502abb1d428e646eb0127"
  end

  resource "cffi" do
    url "https://beta.quicklisp.org/archive/cffi/2017-06-30/cffi_0.19.0.tgz"
    sha256 "49366f97ce20f1a9081b1abce89ab62608dc781dfeb40105a6c98d8b8182638b"
  end

  resource "chipz" do
    url "https://beta.quicklisp.org/archive/chipz/2016-03-18/chipz-20160318-git.tgz"
    sha256 "4620842f94c9431379e9e7e4f27c46381e1730fb1a2c187b39600ed2267afab6"
  end

  resource "chunga" do
    url "https://beta.quicklisp.org/archive/chunga/2018-01-31/chunga-20180131-git.tgz"
    sha256 "38db3685ffe2fdf15cef49a8cc3f2c3082834668d2dd06c84af25065acd93433"
  end

  resource "cl+ssl" do
    url "https://beta.quicklisp.org/archive/cl+ssl/2017-12-27/cl+ssl-20171227-git.tgz"
    sha256 "449f91bddc7274166b8db7546f27bc2912126fdd2f6c802b213f7bc99867dcd4"
  end

  resource "cl-abnf" do
    url "https://beta.quicklisp.org/archive/cl-abnf/2015-06-08/cl-abnf-20150608-git.tgz"
    sha256 "0799bfdc43b7c645934af8c190e58d4d0fac3973ec669ef2feeae0b20f2ca903"
  end

  resource "cl-base64" do
    url "https://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz"
    sha256 "17fab703f316d232b477bd2f8b521283cc0c7410f9b787544f3924007ab95141"
  end

  resource "cl-containers" do
    url "https://beta.quicklisp.org/archive/cl-containers/2017-04-03/cl-containers-20170403-git.tgz"
    sha256 "afafc5d18d07c783e37b1ad6ef29e8bc552292b4ddd5fd7544868cddcb5f9c72"
  end

  resource "cl-csv" do
    url "https://beta.quicklisp.org/archive/cl-csv/2018-01-31/cl-csv-20180131-git.tgz"
    sha256 "900f0278bd9016f875c3c90fabffb0450cf629eb34f76a7d2cbaee1a20132145"
  end

  resource "cl-db3" do
    url "https://beta.quicklisp.org/archive/cl-db3/2015-03-02/cl-db3-20150302-git.tgz"
    sha256 "b1ffd5c0d0e3eca1a505e20e0c4e888a2ec87f37faa9f1fc62adefc6ceba8d57"
  end

  resource "cl-fad" do
    url "https://beta.quicklisp.org/archive/cl-fad/2017-12-27/cl-fad-20171227-git.tgz"
    sha256 "48fdd1fcf89d5f8d3c55c0064a124b35b41cb47061ac20539abb944d67608236"
  end

  resource "cl-interpol" do
    url "https://beta.quicklisp.org/archive/cl-interpol/2017-12-27/cl-interpol-20171227-git.tgz"
    sha256 "fe4f01a27e51d4bb26691e9fa592a92266bbb89df8d4692b88f84d0d11ef9bd4"
  end

  resource "cl-ixf" do
    url "https://beta.quicklisp.org/archive/cl-ixf/2017-06-30/cl-ixf-20170630-git.tgz"
    sha256 "c2d1cbc962c0e3136df4d7e1de65f304aa421fa1ad2fb0e3d1aaf945c7d7d5e1"
  end

  resource "cl-log" do
    url "https://beta.quicklisp.org/archive/cl-log/2013-01-28/cl-log.1.0.1.tgz"
    sha256 "4d7840b9e3bf5a979f780ba937f4e268c73db48e2f91f6c7c541d86e3ac0ab71"
  end

  resource "cl-markdown" do
    url "https://beta.quicklisp.org/archive/cl-markdown/2010-10-06/cl-markdown-20101006-darcs.tgz"
    sha256 "3c1da678be4f7ee71c245fafa56c1b6f4d3e49e7c6d5cc9b5aafc30abf3e3bc3"
  end

  resource "cl-mssql" do
    url "https://beta.quicklisp.org/archive/cl-mssql/2017-06-30/cl-mssql-20170630-git.tgz"
    sha256 "be6fb798a33ceb6bb35fc4e09dcb56144f3e08b66c6d9e35b2f8a29ac6d49a6f"
  end

  resource "cl-ppcre" do
    url "https://beta.quicklisp.org/archive/cl-ppcre/2017-12-27/cl-ppcre-20171227-git.tgz"
    sha256 "84d77df5e6913535deea5d0b7d13e0108da5eaa90034039da2976ad96762b16d"
  end

  resource "cl-sqlite" do
    url "https://beta.quicklisp.org/archive/cl-sqlite/2013-06-15/cl-sqlite-20130615-git.tgz"
    sha256 "105333bbdccc3c2ab76ce4a35c63e6b27ac8a7a0967971c4addd666df7766135"
  end

  resource "cl-unicode" do
    url "https://beta.quicklisp.org/archive/cl-unicode/2018-01-31/cl-unicode-20180131-git.tgz"
    sha256 "aa23b1f9674dc03a241f407fc5e1b4034ba4103d3e653f3f6f9ef02b44d77084"
  end

  resource "cl-utilities" do
    url "https://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz"
    sha256 "07a9318732d73b5195b1a442391d10395c7de471f1fe12feedfe71b1edbd51fc"
  end

  resource "closer-mop" do
    url "https://beta.quicklisp.org/archive/closer-mop/2018-01-31/closer-mop-20180131-git.tgz"
    sha256 "da64623f0070479f24569cfb561559fe9831d910a7c1ecbc2212b5756fbf4e53"
  end

  resource "command-line-arguments" do
    url "https://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz"
    sha256 "d0fba1c0ac361aab4273425079945ee1ac8e7d7e7b9a960026a8c999e41edb1f"
  end

  resource "drakma" do
    url "https://beta.quicklisp.org/archive/drakma/2017-08-30/drakma-v2.0.4.tgz"
    sha256 "ea15c928676c94c484b9c8a093adde274a0d2d439c23871c60be10b102af0d44"
  end

  resource "dynamic-classes" do
    url "https://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz"
    sha256 "4a93d3a39dca61c87b29877fa9707b647fc08f117f80f2a741f649e4d04c4b44"
  end

  resource "esrap" do
    url "https://beta.quicklisp.org/archive/esrap/2018-01-31/esrap-20180131-git.tgz"
    sha256 "6cde96bad96ae2a6784ac321d7323a05db3e3fec5f1b48002b22281ff839f9cd"
  end

  resource "flexi-streams" do
    url "https://beta.quicklisp.org/archive/flexi-streams/2017-12-27/flexi-streams-20171227-git.tgz"
    sha256 "ccbbce21fe146ad7e59c9495bf5128e57329779e9abbf0fb7bfe9eef35e283c3"
  end

  resource "garbage-pools" do
    url "https://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz"
    sha256 "05f014fd95526107af6d99a612b78292fbf3b8a6e9e2efcb04d6ab7e835ab6c5"
  end

  resource "ieee-floats" do
    url "https://beta.quicklisp.org/archive/ieee-floats/2017-08-30/ieee-floats-20170830-git.tgz"
    sha256 "137bc5b3385c35101a6440112757df46570395cdaeed4bf11648353638c18495"
  end

  resource "ironclad" do
    url "https://beta.quicklisp.org/archive/ironclad/2017-11-30/ironclad-v0.37.tgz"
    sha256 "22de0d98a3e5b076676a1a3d1fcd7673058269ce52574b1064fa26e98bb13418"
  end

  resource "iterate" do
    url "https://beta.quicklisp.org/archive/iterate/2018-01-31/iterate-20180131-darcs.tgz"
    sha256 "122698472a6044fd7db8828fd4eb62e8c4b3dbd715a8d3932573049e4ae35416"
  end

  resource "local-time" do
    url "https://beta.quicklisp.org/archive/local-time/2018-01-31/local-time-20180131-git.tgz"
    sha256 "f9e674202596ffe70e82f44e303fa866ce39188990014b42ea334cdc2ca813c5"
  end

  resource "lparallel" do
    url "https://beta.quicklisp.org/archive/lparallel/2016-08-25/lparallel-20160825-git.tgz"
    sha256 "213bc89e6bbabe07fc3bcb21be1021b31f6f2ab1b7a2abb358a01ab9bee69c73"
  end

  resource "md5" do
    url "https://beta.quicklisp.org/archive/md5/2017-06-30/md5-20170630-git.tgz"
    sha256 "ddc3c29843fecf1af5f39346ff91cebadcc4ffb61d3e64698acbcda90722915e"
  end

  resource "metabang-bind" do
    url "https://beta.quicklisp.org/archive/metabang-bind/2017-11-30/metabang-bind-20171130-git.tgz"
    sha256 "2ac820a212756f49b7987f2603c22c8eb10ded912903843f9792e28004794c56"
  end

  resource "metatilities-base" do
    url "https://beta.quicklisp.org/archive/metatilities-base/2017-04-03/metatilities-base-20170403-git.tgz"
    sha256 "799d8a3743660bb98bf517a22aae0c73269061fdf9e69214c3b679f3ee9f8191"
  end

  resource "nibbles" do
    url "https://beta.quicklisp.org/archive/nibbles/2017-11-30/nibbles-20171130-git.tgz"
    sha256 "f61732eaac77db579738b06606bcad25d3e5477970d97b32e4a086a9a2f5d317"
  end

  resource "parse-number" do
    url "https://beta.quicklisp.org/archive/parse-number/2014-08-26/parse-number-1.4.tgz"
    sha256 "90ae04cd1a43fe186d07e5f805faa6cc8a00d1134dd9d99b56e31fa2f5811279"
  end

  resource "postmodern" do
    url "https://beta.quicklisp.org/archive/postmodern/2018-01-31/postmodern-20180131-git.tgz"
    sha256 "7156d15be6271a9afa75e99072fd94d109aa1a008c10eb988ec1df544ebde557"
  end

  resource "puri" do
    url "https://beta.quicklisp.org/archive/puri/2015-09-23/puri-20150923-git.tgz"
    sha256 "0a0784c4d592733c1232fdee1074e9898a091359da142985a44b9528bff02a25"
  end

  resource "py-configparser" do
    url "https://beta.quicklisp.org/archive/py-configparser/2017-08-30/py-configparser-20170830-svn.tgz"
    sha256 "325d2c059deaf3506f69ae7d8c71a0d5aa38a0f3f244a73a0b06676baa30c051"
  end

  resource "qmynd" do
    url "https://beta.quicklisp.org/archive/qmynd/2018-01-31/qmynd-20180131-git.tgz"
    sha256 "2c98ca6500f171744d12bd1bd8476092016787e1c875b13437e3fe9bfd5537e6"
  end

  resource "quri" do
    url "https://beta.quicklisp.org/archive/quri/2016-12-04/quri-20161204-git.tgz"
    sha256 "7b29fe2c2746f2cf59eee703b2ff65b10e6ed2e10232f2c8456657d1e6402e92"
  end

  resource "salza2" do
    url "https://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz"
    sha256 "6aa36dc25fe2dfb411c03ad62edb39fcbf1d4ca8b45ba17a6ad20ebc9f9e10d4"
  end

  resource "split-sequence" do
    url "https://beta.quicklisp.org/archive/split-sequence/2015-08-04/split-sequence-1.2.tgz"
    sha256 "145c5c36e0b4edf77e2cf6df7f8c6b3aa9018211e269cafb97e9631bb7f3a58b"
  end

  resource "trivial-backtrace" do
    url "https://beta.quicklisp.org/archive/trivial-backtrace/2016-05-31/trivial-backtrace-20160531-git.tgz"
    sha256 "1df68d7d0f4a9611e5470cdacae58d594b26cc63b223e89fd85152b119559bed"
  end

  resource "trivial-features" do
    url "https://beta.quicklisp.org/archive/trivial-features/2016-12-04/trivial-features-20161204-git.tgz"
    sha256 "424681538abfa8c5af41fae0099c6e5cb9b05f823a094abba42fcac312f35f44"
  end

  resource "trivial-garbage" do
    url "https://beta.quicklisp.org/archive/trivial-garbage/2015-01-13/trivial-garbage-20150113-git.tgz"
    sha256 "08c0a03595843576835086dc5973cfb535f75f77de4b90e9c9b97c7eba97c1fb"
  end

  resource "trivial-gray-streams" do
    url "https://beta.quicklisp.org/archive/trivial-gray-streams/2014-08-26/trivial-gray-streams-20140826-git.tgz"
    sha256 "22757737e6b63a21f5e7f44980df8047f8c8294c290eeaaaf01bef1f31b80bda"
  end

  resource "trivial-utf-8" do
    url "https://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz"
    sha256 "8b17c345da11796663cfd04584445c62f09e789981a83ebefe7970a30b0aafd2"
  end

  resource "uiop" do
    url "https://beta.quicklisp.org/archive/uiop/2017-12-27/uiop-3.3.1.tgz"
    sha256 "0cbe1012899f1b1584f954bcb265d306b974ebd9141f97b476879adc00513b71"
  end

  resource "usocket" do
    url "https://beta.quicklisp.org/archive/usocket/2016-10-31/usocket-0.7.0.1.tgz"
    sha256 "c2454e8d8f65bf81aadf877d65d9b6364ed25f8560ad405063e2b4bfb872ecd6"
  end

  resource "uuid" do
    url "https://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz"
    sha256 "0e8657bdf7ad131641f6d878f953ebf74d3cda06b8be99dd8bb8cffbe34308de"
  end

  def install
    resources.each do |resource|
      resource.stage buildpath/"lib"/resource.name
    end

    ENV["CL_SOURCE_REGISTRY"] = "#{buildpath}/lib//:#{buildpath}//"
    ENV["ASDF_OUTPUT_TRANSLATIONS"] = "/:/"
    system "make", "pgloader-standalone", "BUILDAPP=buildapp"

    bin.install "build/bin/pgloader"
    man1.install "pgloader.1"
  end

  def launch_postgres(socket_dir)
    require "timeout"

    socket_dir = Pathname.new(socket_dir)
    mkdir_p socket_dir

    postgres_command = [
      "postgres",
      "--listen_addresses=",
      "--unix_socket_directories=#{socket_dir}",
    ]

    IO.popen(postgres_command * " ") do |postgres|
      begin
        ohai postgres_command * " "
        # Postgres won't create the socket until it's ready for connections, but
        # if it fails to start, we'll be waiting for the socket forever. So we
        # time out quickly; this is simpler than mucking with child process
        # signals.
        Timeout.timeout(5) { sleep 0.2 while socket_dir.children.empty? }
        yield
      ensure
        Process.kill(:TERM, postgres.pid)
      end
    end
  end

  test do
    # Remove any Postgres environment variables that might prevent us from
    # isolating this disposable copy of Postgres.
    ENV.reject! { |key, _| key.start_with?("PG") }

    ENV["PGDATA"] = testpath/"data"
    ENV["PGHOST"] = testpath/"socket"
    ENV["PGDATABASE"] = "brew"

    (testpath/"test.load").write <<~EOS
      LOAD CSV
        FROM inline (code, country)
        INTO postgresql:///#{ENV["PGDATABASE"]}?tablename=csv
        WITH fields terminated by ','

      BEFORE LOAD DO
        $$ CREATE TABLE csv (code char(2), country text); $$;

      GB,United Kingdom
      US,United States
      CA,Canada
      US,United States
      GB,United Kingdom
      CA,Canada
    EOS

    system "initdb"

    launch_postgres(ENV["PGHOST"]) do
      system "createdb"
      system "#{bin}/pgloader", testpath/"test.load"
      assert_equal "6", shell_output("psql -Atc 'SELECT COUNT(*) FROM csv'").strip
    end
  end
end
