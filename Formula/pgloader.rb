class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/archive/v3.5.2.tar.gz"
  sha256 "1a07a91db6b5e0d96c43fed3e429d49d920d71ca31c4f50929529b6fe75665ae"
  head "https://github.com/dimitri/pgloader.git"

  bottle do
    sha256 "76b19db15b4574a9297d5b37ff170ea428b5e0954097c77fe75a0d83d79dfb85" => :high_sierra
    sha256 "9cdf7c6276fff08858d0fd4ddc46c659a9ea5578baa24fb2584f780a544dced7" => :sierra
    sha256 "125532b10e7cbbc7f3246290ce0d3ea1915c68f1e1b6d6277b4875f316c20fd2" => :el_capitan
  end

  depends_on "buildapp" => :build
  depends_on "sphinx-doc" => :build
  depends_on "freetds"
  depends_on "sbcl"
  depends_on "postgresql" => :recommended

  # Resource stanzas are generated automatically by quicklisp-roundup.
  # See: https://github.com/benesch/quicklisp-homebrew-roundup

  resource "alexandria" do
    url "https://beta.quicklisp.org/archive/alexandria/2017-08-30/alexandria-20170830-git.tgz"
    sha256 "894e54f77594b13137b5b8ec05937ad6b78bc15c4630ffd1e550e1f226a2f96e"
  end

  resource "anaphora" do
    url "https://beta.quicklisp.org/archive/anaphora/2018-02-28/anaphora-20180228-git.tgz"
    sha256 "8134f1c629a63b4504dc973984655f707f9977a623bd9a310786b8d6f3aea2ad"
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
    url "https://beta.quicklisp.org/archive/cffi/2018-02-28/cffi_0.19.0.tgz"
    sha256 "49366f97ce20f1a9081b1abce89ab62608dc781dfeb40105a6c98d8b8182638b"
  end

  resource "chipz" do
    url "https://beta.quicklisp.org/archive/chipz/2018-03-28/chipz-20180328-git.tgz"
    sha256 "c7754335cabf87a4e0d1facb774f4b1ae11dfbf7cdc694cefa53fa4fb3cbd267"
  end

  resource "chunga" do
    url "https://beta.quicklisp.org/archive/chunga/2018-01-31/chunga-20180131-git.tgz"
    sha256 "38db3685ffe2fdf15cef49a8cc3f2c3082834668d2dd06c84af25065acd93433"
  end

  resource "cl+ssl" do
    url "https://beta.quicklisp.org/archive/cl+ssl/2018-03-28/cl+ssl-20180328-git.tgz"
    sha256 "c248aa12938f55a1088187e84da18c4b252a8e2496f82c5755f247401bb0b924"
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
    url "https://beta.quicklisp.org/archive/cl-csv/2018-02-28/cl-csv-20180228-git.tgz"
    sha256 "7924fc4baf5a5592a6b410e303d3ab495ce3748a3e44ec68b671a423bb8fcdf5"
  end

  resource "cl-db3" do
    url "https://beta.quicklisp.org/archive/cl-db3/2015-03-02/cl-db3-20150302-git.tgz"
    sha256 "b1ffd5c0d0e3eca1a505e20e0c4e888a2ec87f37faa9f1fc62adefc6ceba8d57"
  end

  resource "cl-fad" do
    url "https://beta.quicklisp.org/archive/cl-fad/2018-04-30/cl-fad-20180430-git.tgz"
    sha256 "9a051defe62f5c168003dc1c928d3a5cd74b08b7c831d51562171b2c8637bb9c"
  end

  resource "cl-interpol" do
    url "https://beta.quicklisp.org/archive/cl-interpol/2017-12-27/cl-interpol-20171227-git.tgz"
    sha256 "fe4f01a27e51d4bb26691e9fa592a92266bbb89df8d4692b88f84d0d11ef9bd4"
  end

  resource "cl-ixf" do
    url "https://beta.quicklisp.org/archive/cl-ixf/2018-02-28/cl-ixf-20180228-git.tgz"
    sha256 "7adba0bf221f6f91777457c9d6c52a0a7e034c628e18f09c7445ce50a8ff14fb"
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
    url "https://beta.quicklisp.org/archive/cl-mssql/2018-02-28/cl-mssql-20180228-git.tgz"
    sha256 "a07288fd3e26c83eb49f191b9f0db3b3c65f1370f34586120a7b93ded1c13bb9"
  end

  resource "cl-mustache" do
    url "https://beta.quicklisp.org/archive/cl-mustache/2015-09-23/cl-mustache-20150923-git.tgz"
    sha256 "22b0938a3765229a54bd84f70c7de2a56e8903fef4dbc987a3c8621314d800e4"
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
    url "https://beta.quicklisp.org/archive/cl-unicode/2018-03-28/cl-unicode-20180328-git.tgz"
    sha256 "96dec5e7f874df77791093246c426e896af101f1fb63864fdbfe291d37c4c8cf"
  end

  resource "cl-utilities" do
    url "https://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz"
    sha256 "07a9318732d73b5195b1a442391d10395c7de471f1fe12feedfe71b1edbd51fc"
  end

  resource "closer-mop" do
    url "https://beta.quicklisp.org/archive/closer-mop/2018-04-30/closer-mop-20180430-git.tgz"
    sha256 "db2cdae1d3e59637484ee6c4095906adb3ac68bb185f6dfc7fed042ef1947bad"
  end

  resource "closure-common" do
    url "https://beta.quicklisp.org/archive/closure-common/2010-11-07/closure-common-20101107-git.tgz"
    sha256 "64c2b19fd64be8606f8208191b3269022e8fe34abe3f72acfd349f2fec6d02a5"
  end

  resource "command-line-arguments" do
    url "https://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz"
    sha256 "d0fba1c0ac361aab4273425079945ee1ac8e7d7e7b9a960026a8c999e41edb1f"
  end

  resource "cxml" do
    url "https://beta.quicklisp.org/archive/cxml/2011-06-19/cxml-20110619-git.tgz"
    sha256 "d38bbad4b2d8f519f9e13402cd322ceb8a38934d4b4d82e2571a9f9bacd76612"
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
    url "https://beta.quicklisp.org/archive/esrap/2018-04-30/esrap-20180430-git.tgz"
    sha256 "5ba9ee9285b4244884b8d636e424eaf88176954d303aba48b6119aaabf1d63f3"
  end

  resource "flexi-streams" do
    url "https://beta.quicklisp.org/archive/flexi-streams/2018-03-28/flexi-streams-20180328-git.tgz"
    sha256 "21707f3682009e291f6d9d9ed67e74f1ddad4ae073ba96cc319b8f1861fcb541"
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
    url "https://beta.quicklisp.org/archive/ironclad/2018-04-30/ironclad-v0.39.tgz"
    sha256 "080ef9df4bc20a118c53a7e71e6077eccec647b125d33f064367c7d8ed32155b"
  end

  resource "iterate" do
    url "https://beta.quicklisp.org/archive/iterate/2018-02-28/iterate-20180228-git.tgz"
    sha256 "2b1e968360ffe6296b8de3c2ad916ab59a92d146bdc4e59a131b9dd3af6ee52f"
  end

  resource "local-time" do
    url "https://beta.quicklisp.org/archive/local-time/2018-02-28/local-time-20180228-git.tgz"
    sha256 "a1ae2789780f2e6ec8f6a0ba7d83c60eb2878117a4edbc221995649951cd6868"
  end

  resource "lparallel" do
    url "https://beta.quicklisp.org/archive/lparallel/2016-08-25/lparallel-20160825-git.tgz"
    sha256 "213bc89e6bbabe07fc3bcb21be1021b31f6f2ab1b7a2abb358a01ab9bee69c73"
  end

  resource "md5" do
    url "https://beta.quicklisp.org/archive/md5/2018-02-28/md5-20180228-git.tgz"
    sha256 "a4599d7733cfede17d3b47ab30eab330fb3781d2d3c83b17ea5eceba4c8fc188"
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
    url "https://beta.quicklisp.org/archive/nibbles/2018-04-30/nibbles-20180430-git.tgz"
    sha256 "8f0c4893472d24475daa95830efcad7999c2a60c4cd1837bdbc65c0cf8e9e9fc"
  end

  resource "parse-number" do
    url "https://beta.quicklisp.org/archive/parse-number/2018-02-28/parse-number-v1.7.tgz"
    sha256 "0a6a6b9a7a351306c4eae1ab1c3a8a0e2a88fafb8133124b9cb8de680a425186"
  end

  resource "postmodern" do
    url "https://beta.quicklisp.org/archive/postmodern/2018-04-30/postmodern-20180430-git.tgz"
    sha256 "ee2866c7d4261b8a81956ce0b4a285bd04a3edd49e3217b619602e188b43dc2c"
  end

  resource "puri" do
    url "https://beta.quicklisp.org/archive/puri/2018-02-28/puri-20180228-git.tgz"
    sha256 "7fd9fce21a83fb6d4f42bf146bdc6e5e36d8e95c6cf5427cd6aa78999b2a99e8"
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

  resource "split-sequence" do
    url "https://beta.quicklisp.org/archive/split-sequence/2018-02-28/split-sequence-v1.4.1.tgz"
    sha256 "78e07795414ed97b5809363f145bbcb0610b2767eb5ca96f210c624a1b334f11"
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
    url "https://beta.quicklisp.org/archive/trivial-gray-streams/2018-03-28/trivial-gray-streams-20180328-git.tgz"
    sha256 "ce8085287b3e4ab78e17fc164b6a45d58b8c1f7e43c3aff67dbb0010ceade507"
  end

  resource "trivial-utf-8" do
    url "https://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz"
    sha256 "8b17c345da11796663cfd04584445c62f09e789981a83ebefe7970a30b0aafd2"
  end

  resource "usocket" do
    url "https://beta.quicklisp.org/archive/usocket/2016-10-31/usocket-0.7.0.1.tgz"
    sha256 "c2454e8d8f65bf81aadf877d65d9b6364ed25f8560ad405063e2b4bfb872ecd6"
  end

  resource "uuid" do
    url "https://beta.quicklisp.org/archive/uuid/2013-08-13/uuid-20130813-git.tgz"
    sha256 "0e8657bdf7ad131641f6d878f953ebf74d3cda06b8be99dd8bb8cffbe34308de"
  end

  resource "yason" do
    url "https://beta.quicklisp.org/archive/yason/2016-02-08/yason-v0.7.6.tgz"
    sha256 "1332170b030067e2ea7119e8a18abb7778b89fd6a2163f808d80dbbd48b0ee01"
  end

  resource "zs3" do
    url "https://beta.quicklisp.org/archive/zs3/2017-12-27/zs3-1.3.1.tgz"
    sha256 "ddd9e180d23bce21482cb0d9bcd3f5636c85963290ac19fa9ddc39fa9b12b990"
  end

  def install
    resources.each do |resource|
      resource.stage buildpath/"lib"/resource.name
    end

    ENV["CL_SOURCE_REGISTRY"] = "#{buildpath}/lib//:#{buildpath}//"
    ENV["ASDF_OUTPUT_TRANSLATIONS"] = "/:/"
    system "make", "pgloader-standalone", "BUILDAPP=buildapp"

    bin.install "build/bin/pgloader"

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/pgloader.1"
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
      output = shell_output("psql -Atc 'SELECT COUNT(*) FROM csv'")
      assert_equal "6", output.lines.last.chomp
    end
  end
end
