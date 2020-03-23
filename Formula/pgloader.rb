class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/archive/v3.6.2.tar.gz"
  sha256 "33f87df9cb8f9a36f9836cd691ad6dfa72ae76200a12fe01ee89584f3b771ae7"
  head "https://github.com/dimitri/pgloader.git"

  bottle do
    sha256 "870f4b67576b1a7f652a2ffb1a508c127426ae55adb073c6e8efa25ee6d01628" => :catalina
    sha256 "e87456a8048c63e5624ab36ee6c2092b87138b9a21634e8cf308b54dbb9cd2f4" => :mojave
    sha256 "065e0d320ec25662d3dbd345005c197e2c53b766e5818d53b16bd204362abcf0" => :high_sierra
  end

  depends_on "buildapp" => :build
  depends_on "sphinx-doc" => :build
  depends_on "freetds"
  depends_on "openssl@1.1"
  depends_on "postgresql"
  depends_on "sbcl"

  # Resource stanzas are generated automatically by quicklisp-roundup.
  # See: https://github.com/benesch/quicklisp-homebrew-roundup

  resource "alexandria" do
    url "https://beta.quicklisp.org/archive/alexandria/2020-02-18/alexandria-20200218-git.tgz"
    sha256 "d98d2413f8795fc7a6147c15f24b3cab9823d21c268524aa28b66e343cdd05ba"
  end

  resource "anaphora" do
    url "https://beta.quicklisp.org/archive/anaphora/2019-10-07/anaphora-20191007-git.tgz"
    sha256 "7b9e235272daef16340129909b21e678b05e5aa3215b0977ca927936606b8e47"
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
    url "https://beta.quicklisp.org/archive/babel/2020-02-18/babel-20200218-git.tgz"
    sha256 "d3ae4985e7d75473a443866654234770e2d709c2294b2dd421e6a2f39bb62a52"
  end

  resource "bordeaux-threads" do
    url "https://beta.quicklisp.org/archive/bordeaux-threads/2019-11-30/bordeaux-threads-v0.8.7.tgz"
    sha256 "dcd02195af9161f4067995cf23d31cc9196326a20f541bad83de9a50d573c8aa"
  end

  resource "cffi" do
    url "https://beta.quicklisp.org/archive/cffi/2020-02-18/cffi_0.21.0.tgz"
    sha256 "45f22eb261925fbe79a43ed73a29a89cca7691b4714551b6a536c053dde27331"
  end

  resource "chipz" do
    url "https://beta.quicklisp.org/archive/chipz/2019-02-02/chipz-20190202-git.tgz"
    sha256 "aa58d80c12151f854b647b4d730ca29bba24c57f8954cb9ae777ee2968b568ee"
  end

  resource "chunga" do
    url "https://beta.quicklisp.org/archive/chunga/2018-01-31/chunga-20180131-git.tgz"
    sha256 "38db3685ffe2fdf15cef49a8cc3f2c3082834668d2dd06c84af25065acd93433"
  end

  resource "cl+ssl" do
    url "https://beta.quicklisp.org/archive/cl+ssl/2019-11-30/cl+ssl-20191130-git.tgz"
    sha256 "43e86a3b3ff49c87435102f0653854620219863dcf900d2bc55a82d505526b1c"
  end

  resource "cl-abnf" do
    url "https://beta.quicklisp.org/archive/cl-abnf/2019-05-21/cl-abnf-20190521-git.tgz"
    sha256 "449a492271397eb93b8263f32c99c002712c587e5001562f75b39569c85c13b5"
  end

  resource "cl-base64" do
    url "https://beta.quicklisp.org/archive/cl-base64/2015-09-23/cl-base64-20150923-git.tgz"
    sha256 "17fab703f316d232b477bd2f8b521283cc0c7410f9b787544f3924007ab95141"
  end

  resource "cl-containers" do
    url "https://beta.quicklisp.org/archive/cl-containers/2020-02-18/cl-containers-20200218-git.tgz"
    sha256 "cdeaa7651313e84af739006717f81ba5b475d472d492f1eff3a32371d7101d39"
  end

  resource "cl-csv" do
    url "https://beta.quicklisp.org/archive/cl-csv/2018-08-31/cl-csv-20180831-git.tgz"
    sha256 "cda57a231fade697de7531c433fcfbd6f03cc0b7854e706bacd0b051bfbdc233"
  end

  resource "cl-db3" do
    url "https://beta.quicklisp.org/archive/cl-db3/2020-02-18/cl-db3-20200218-git.tgz"
    sha256 "4f3b47f37faddf70866aa6e4be234036eb64a32300c9670e4f66ad2f97b245f1"
  end

  resource "cl-fad" do
    url "https://beta.quicklisp.org/archive/cl-fad/2020-02-18/cl-fad-20200218-git.tgz"
    sha256 "0173da3142d675bb5b2fb3374a08967aaea5d41c46b00bd8460fc6b448c58151"
  end

  resource "cl-interpol" do
    url "https://beta.quicklisp.org/archive/cl-interpol/2018-07-11/cl-interpol-20180711-git.tgz"
    sha256 "196895b193f955488e51e2f69c2afca8adb9beeca0e2cdfc80c9a7c866a908e9"
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
    url "https://beta.quicklisp.org/archive/cl-markdown/2019-12-27/cl-markdown-20191227-git.tgz"
    sha256 "0d7187af7f42e8fb134d488e58050f865138d59c0aeeff5a2db825b5c1723b2d"
  end

  resource "cl-mssql" do
    url "https://beta.quicklisp.org/archive/cl-mssql/2019-08-13/cl-mssql-20190813-git.tgz"
    sha256 "546ab74ea379d25f56ea32e9458daf3d83051131c6acc14a164bb9c48eb0e56c"
  end

  resource "cl-mustache" do
    url "https://beta.quicklisp.org/archive/cl-mustache/2015-09-23/cl-mustache-20150923-git.tgz"
    sha256 "22b0938a3765229a54bd84f70c7de2a56e8903fef4dbc987a3c8621314d800e4"
  end

  resource "cl-ppcre" do
    url "https://beta.quicklisp.org/archive/cl-ppcre/2019-05-21/cl-ppcre-20190521-git.tgz"
    sha256 "1d4b08ea962612ba92cec7c6f5bb0b8e82efddb91affa0007ada3a95dc66d25c"
  end

  resource "cl-sqlite" do
    url "https://beta.quicklisp.org/archive/cl-sqlite/2019-08-13/cl-sqlite-20190813-git.tgz"
    sha256 "b3e68114ead48de09b6042806ef05e8bed7eb7086e0ce9f5afef9d78a050f41f"
  end

  resource "cl-unicode" do
    url "https://beta.quicklisp.org/archive/cl-unicode/2019-05-21/cl-unicode-20190521-git.tgz"
    sha256 "ecd90df05f53cec0a33eb504b9d3af0356832ad84cc0ddb3d5dc0dbb70f6405c"
  end

  resource "cl-utilities" do
    url "https://beta.quicklisp.org/archive/cl-utilities/2010-10-06/cl-utilities-1.2.4.tgz"
    sha256 "07a9318732d73b5195b1a442391d10395c7de471f1fe12feedfe71b1edbd51fc"
  end

  resource "closer-mop" do
    url "https://beta.quicklisp.org/archive/closer-mop/2020-02-18/closer-mop-20200218-git.tgz"
    sha256 "f3d6d885ab23a90c0a0152bb26bd4acef06a8559e74ff1b7f06fe8c226e513b0"
  end

  resource "closure-common" do
    url "https://beta.quicklisp.org/archive/closure-common/2018-10-18/closure-common-20181018-git.tgz"
    sha256 "f6f60bdff5e6c2e41bbab98c44a3b4dedaa4f91047b9042ed330a9daad3c77a1"
  end

  resource "command-line-arguments" do
    url "https://beta.quicklisp.org/archive/command-line-arguments/2019-12-27/command-line-arguments-20191227-git.tgz"
    sha256 "ee6905d4c75a67361ca0e399b632adec1916af3e97f174b77218c55685d886a0"
  end

  resource "cxml" do
    url "https://beta.quicklisp.org/archive/cxml/2018-10-18/cxml-20181018-git.tgz"
    sha256 "b6e6391a1f1237c8cbbe6c540c40a3f510e9501fef010bbdcaba5ff70b76f6e8"
  end

  resource "drakma" do
    url "https://beta.quicklisp.org/archive/drakma/2019-11-30/drakma-v2.0.7.tgz"
    sha256 "fc4f54a4b21632ded510a58b420b5a61e6772ce2f2abe53d11d89dae2d801ae4"
  end

  resource "dynamic-classes" do
    url "https://beta.quicklisp.org/archive/dynamic-classes/2013-01-28/dynamic-classes-20130128-git.tgz"
    sha256 "4a93d3a39dca61c87b29877fa9707b647fc08f117f80f2a741f649e4d04c4b44"
  end

  resource "esrap" do
    url "https://beta.quicklisp.org/archive/esrap/2020-02-18/esrap-20200218-git.tgz"
    sha256 "114f16c0266a317ddaa7d0e8e48acd6b91d6378d435e65694b34e7c6c4a2296a"
  end

  resource "flexi-streams" do
    url "https://beta.quicklisp.org/archive/flexi-streams/2019-01-07/flexi-streams-20190107-git.tgz"
    sha256 "259a64ec4f19da7abf64296864a4019daf53c330d1dc9945cefb377df59e13bb"
  end

  resource "garbage-pools" do
    url "https://beta.quicklisp.org/archive/garbage-pools/2013-07-20/garbage-pools-20130720-git.tgz"
    sha256 "05f014fd95526107af6d99a612b78292fbf3b8a6e9e2efcb04d6ab7e835ab6c5"
  end

  resource "global-vars" do
    url "https://beta.quicklisp.org/archive/global-vars/2014-11-06/global-vars-20141106-git.tgz"
    sha256 "f294843bb31144034e1370df1634dd74f24e617e3abb9c00c17927eda2ae4f2e"
  end

  resource "ieee-floats" do
    url "https://beta.quicklisp.org/archive/ieee-floats/2017-08-30/ieee-floats-20170830-git.tgz"
    sha256 "137bc5b3385c35101a6440112757df46570395cdaeed4bf11648353638c18495"
  end

  resource "ironclad" do
    url "https://beta.quicklisp.org/archive/ironclad/2020-02-18/ironclad-v0.48.tgz"
    sha256 "3715a9358627667d29382c1d3ecd39688ec810c90e79dce343e321ca2bded6c3"
  end

  resource "iterate" do
    url "https://beta.quicklisp.org/archive/iterate/2018-02-28/iterate-20180228-git.tgz"
    sha256 "2b1e968360ffe6296b8de3c2ad916ab59a92d146bdc4e59a131b9dd3af6ee52f"
  end

  resource "local-time" do
    url "https://beta.quicklisp.org/archive/local-time/2019-07-10/local-time-20190710-git.tgz"
    sha256 "5396e34bdfe2b3ac5fcc070f52a1a62abb7161e3c464ef1bf64cacecc82bd4b8"
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
    url "https://beta.quicklisp.org/archive/metabang-bind/2020-02-18/metabang-bind-20200218-git.tgz"
    sha256 "1806db96b93b64450c7eb7665d606582c424a8fddf35caa14ad16cb4b5fbd255"
  end

  resource "metatilities-base" do
    url "https://beta.quicklisp.org/archive/metatilities-base/2019-12-27/metatilities-base-20191227-git.tgz"
    sha256 "347215567615e2139965d8b0f8f72e3c47bb65e3837226a950dece7a6e2854d5"
  end

  resource "named-readtables" do
    url "https://beta.quicklisp.org/archive/named-readtables/2020-02-18/named-readtables-20200218-git.tgz"
    sha256 "0f835698ee26ec0b736742da86362c0cdcdb5eae0f582181df07259c9b9c5ecf"
  end

  resource "parse-number" do
    url "https://beta.quicklisp.org/archive/parse-number/2018-02-28/parse-number-v1.7.tgz"
    sha256 "0a6a6b9a7a351306c4eae1ab1c3a8a0e2a88fafb8133124b9cb8de680a425186"
  end

  resource "postmodern" do
    url "https://beta.quicklisp.org/archive/postmodern/2020-02-18/postmodern-20200218-git.tgz"
    sha256 "375f1f1fcf048362ee0a1e42788dc32b9dfc664b255867100b5472aded0e6f13"
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
    url "https://beta.quicklisp.org/archive/qmynd/2019-07-10/qmynd-20190710-git.tgz"
    sha256 "e29f2d7edc55d0c262a3221d330daef38e5303851fb660ac0377804980e604c4"
  end

  resource "quri" do
    url "https://beta.quicklisp.org/archive/quri/2019-11-30/quri-20191130-git.tgz"
    sha256 "7acd2b92a3de04ae7199e3914dbe195236044ab5820be117253c20465c0f4702"
  end

  resource "salza2" do
    url "https://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz"
    sha256 "6aa36dc25fe2dfb411c03ad62edb39fcbf1d4ca8b45ba17a6ad20ebc9f9e10d4"
  end

  resource "split-sequence" do
    url "https://beta.quicklisp.org/archive/split-sequence/2019-05-21/split-sequence-v2.0.0.tgz"
    sha256 "6aa973591b2ba75a07774638f4702cdf329c2aa668e3f7e9866a06fab9ae9525"
  end

  resource "trivial-backtrace" do
    url "https://beta.quicklisp.org/archive/trivial-backtrace/2019-07-10/trivial-backtrace-20190710-git.tgz"
    sha256 "3dbda4c4a4e742649f6c0cffd2c5b9847f8192370f6770c47dbaf01167b1ff06"
  end

  resource "trivial-features" do
    url "https://beta.quicklisp.org/archive/trivial-features/2020-02-18/trivial-features-20200218-git.tgz"
    sha256 "6800a2ac4987d21af4e2db06206e51912f8b766039c5d6e75f29ef6f262ac120"
  end

  resource "trivial-garbage" do
    url "https://beta.quicklisp.org/archive/trivial-garbage/2019-05-21/trivial-garbage-20190521-git.tgz"
    sha256 "b439d4c011f9b0842c92a32c6cd44c611b94ebb623f0b5397ccfb195673e0b7a"
  end

  resource "trivial-gray-streams" do
    url "https://beta.quicklisp.org/archive/trivial-gray-streams/2018-10-18/trivial-gray-streams-20181018-git.tgz"
    sha256 "3b921381df112515661c174fafa04adf11cf4620ebd7e2cc1d7bfd548fab2d28"
  end

  resource "trivial-utf-8" do
    url "https://beta.quicklisp.org/archive/trivial-utf-8/2011-10-01/trivial-utf-8-20111001-darcs.tgz"
    sha256 "8b17c345da11796663cfd04584445c62f09e789981a83ebefe7970a30b0aafd2"
  end

  resource "uiop" do
    url "https://beta.quicklisp.org/archive/uiop/2020-02-18/uiop-3.3.4.tgz"
    sha256 "5ba983536c94677b07cee5d7616dbad76a31edb3b371afe07f26f21d4bb90e58"
  end

  resource "usocket" do
    url "https://beta.quicklisp.org/archive/usocket/2019-12-27/usocket-0.8.3.tgz"
    sha256 "a7d2d1cceea267da146310621c614dcf6226385f271efba946ba6299b238f4a5"
  end

  resource "uuid" do
    url "https://beta.quicklisp.org/archive/uuid/2018-08-31/uuid-20180831-git.tgz"
    sha256 "3b48ac4db2174100ad45121be09f7245dfbe3897637989b103b2de06581512c2"
  end

  resource "yason" do
    url "https://beta.quicklisp.org/archive/yason/2019-12-27/yason-v0.7.8.tgz"
    sha256 "c1193980a3588f163ecfd7810f221fbafa9fb8d1032e9ed5d5dd121e450ca585"
  end

  resource "zs3" do
    url "https://beta.quicklisp.org/archive/zs3/2019-10-07/zs3-1.3.3.tgz"
    sha256 "d6b5e2958f68957269147a1047e9a4f619d6e18be98e68021e2c8ef208fbccb5"
  end

  def install
    resources.each do |resource|
      resource.stage buildpath/"lib"/resource.name
    end

    inreplace buildpath/"lib/cl+ssl/src/reload.lisp", "/usr/local/opt/openssl/lib/libcrypto.dylib",
                                                      Formula["openssl@1.1"].opt_lib/"libcrypto.dylib"
    inreplace buildpath/"lib/cl+ssl/src/reload.lisp", "/usr/local/opt/openssl/lib/libssl.dylib",
                                                      Formula["openssl@1.1"].opt_lib/"libssl.dylib"

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

  test do
    return if ENV["CI"]

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
