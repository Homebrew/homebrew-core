class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/archive/v3.6.1.tar.gz"
  sha256 "6fa94f2e8e9c94c5f7700c02b61b97a17092bd87b3b77b3d84a06a1fb98b09fa"
  head "https://github.com/dimitri/pgloader.git"

  bottle do
    sha256 "38db7f6a7695e08463a32172d9b31a14766fbfe8c7aaa4c552c9336537be6d5d" => :mojave
    sha256 "3d569cdcdc3a27a6a0401582dd09b21aecf2032ec13e6df29d7f92c087857e84" => :high_sierra
    sha256 "d4f9b42c3ec8d2794b887d659e7da03390f799cbfcbca0defa6c5387a6dbe00a" => :sierra
  end

  depends_on "buildapp" => :build
  depends_on "sphinx-doc" => :build
  depends_on "freetds"
  depends_on "postgresql"
  depends_on "sbcl"

  # Resource stanzas are generated automatically by quicklisp-roundup.
  # See: https://github.com/benesch/quicklisp-homebrew-roundup

  resource "alexandria" do
    url "https://beta.quicklisp.org/archive/alexandria/2018-12-10/alexandria-20181210-git.tgz"
    sha256 "0815417337258ccf3417a374f2f0222552f643447f6980353834e7c74e7ee035"
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
    url "https://beta.quicklisp.org/archive/bordeaux-threads/2018-07-11/bordeaux-threads-v0.8.6.tgz"
    sha256 "3ee42f65c46801d9277f37ce2253531164c40ead7fe7b255344f80ef574b6be0"
  end

  resource "cffi" do
    url "https://beta.quicklisp.org/archive/cffi/2018-12-10/cffi_0.20.0.tgz"
    sha256 "1f55086d6bf7badea03861f0705bf55e6db7a9ec27292479611a5cdc403e54c9"
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
    url "https://beta.quicklisp.org/archive/cl+ssl/2019-03-07/cl+ssl-20190307-git.tgz"
    sha256 "c602029dd9619d922b5859dab126b47d0f85a1f84664599215ad0efb444cf2e7"
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
    url "https://beta.quicklisp.org/archive/cl-csv/2018-08-31/cl-csv-20180831-git.tgz"
    sha256 "cda57a231fade697de7531c433fcfbd6f03cc0b7854e706bacd0b051bfbdc233"
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
    url "https://beta.quicklisp.org/archive/cl-markdown/2018-12-10/cl-markdown-20181210-git.tgz"
    sha256 "3527c2e3674930ab2059b2559300fcaf2d5e5da6a86df56483cf0b66a9dff979"
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
    url "https://beta.quicklisp.org/archive/cl-ppcre/2018-08-31/cl-ppcre-20180831-git.tgz"
    sha256 "cbbf0cdac87f39a52d5d7e4ac3144023a09f57ad49ff8bed4f9dcbcfc583a60f"
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
    url "https://beta.quicklisp.org/archive/closer-mop/2019-03-07/closer-mop-20190307-git.tgz"
    sha256 "dd2b2b592d77d6277b4380a81827e57a7ecd902d822bb40eeff59e2aacd9aaeb"
  end

  resource "closure-common" do
    url "https://beta.quicklisp.org/archive/closure-common/2018-10-18/closure-common-20181018-git.tgz"
    sha256 "f6f60bdff5e6c2e41bbab98c44a3b4dedaa4f91047b9042ed330a9daad3c77a1"
  end

  resource "command-line-arguments" do
    url "https://beta.quicklisp.org/archive/command-line-arguments/2015-12-18/command-line-arguments-20151218-git.tgz"
    sha256 "d0fba1c0ac361aab4273425079945ee1ac8e7d7e7b9a960026a8c999e41edb1f"
  end

  resource "cxml" do
    url "https://beta.quicklisp.org/archive/cxml/2018-10-18/cxml-20181018-git.tgz"
    sha256 "b6e6391a1f1237c8cbbe6c540c40a3f510e9501fef010bbdcaba5ff70b76f6e8"
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
    url "https://beta.quicklisp.org/archive/esrap/2019-01-07/esrap-20190107-git.tgz"
    sha256 "ba97f0aa15f4a0faa77a23665fcb353aa633f752e179704d9198ecd3d8d7644d"
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
    url "https://beta.quicklisp.org/archive/ironclad/2019-03-07/ironclad-v0.45.tgz"
    sha256 "02df42541cc8a72eb896da8b6e0f7b563af5980a0ae07355fd8afa8528856eeb"
  end

  resource "iterate" do
    url "https://beta.quicklisp.org/archive/iterate/2018-02-28/iterate-20180228-git.tgz"
    sha256 "2b1e968360ffe6296b8de3c2ad916ab59a92d146bdc4e59a131b9dd3af6ee52f"
  end

  resource "local-time" do
    url "https://beta.quicklisp.org/archive/local-time/2019-02-02/local-time-20190202-git.tgz"
    sha256 "c2e2d826f4eb0d7e6903d9b74c3a9dae807c57a06de55c70fe88c26d110194e5"
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

  resource "named-readtables" do
    url "https://beta.quicklisp.org/archive/named-readtables/2018-01-31/named-readtables-20180131-git.tgz"
    sha256 "e5bdcc3f0ef9265785baebbfd5f1c8f41f7a12e8b5dfab8cafa69683457d1eba"
  end

  resource "nibbles" do
    url "https://beta.quicklisp.org/archive/nibbles/2018-08-31/nibbles-20180831-git.tgz"
    sha256 "8a1e81dde6603b2e836e8b240f0ac41dec2508b51be75b860edf5e52be70457c"
  end

  resource "parse-number" do
    url "https://beta.quicklisp.org/archive/parse-number/2018-02-28/parse-number-v1.7.tgz"
    sha256 "0a6a6b9a7a351306c4eae1ab1c3a8a0e2a88fafb8133124b9cb8de680a425186"
  end

  resource "pgloader" do
    url "https://beta.quicklisp.org/archive/pgloader/2019-02-02/pgloader-v3.6.1.tgz"
    sha256 "ef8091f427ff9cef81576351597e6b863014f01eaf1c0af3e77fcf8a6b9ea925"
  end

  resource "postmodern" do
    url "https://beta.quicklisp.org/archive/postmodern/2019-03-07/postmodern-20190307-git.tgz"
    sha256 "9033462aeffdbc04522074462b7f9d6f88016675ece232fa9b8cfabba08de926"
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
    url "https://beta.quicklisp.org/archive/qmynd/2019-02-02/qmynd-20190202-git.tgz"
    sha256 "bdbd16fecb35fa3835a4823944490936f46878698be3dffced0978e063cd441f"
  end

  resource "quri" do
    url "https://beta.quicklisp.org/archive/quri/2018-12-10/quri-20181210-git.tgz"
    sha256 "c47a398dae09d15dd0695fb7f151107a313e7f118319aa0ad707c8f064c0c247"
  end

  resource "salza2" do
    url "https://beta.quicklisp.org/archive/salza2/2013-07-20/salza2-2.0.9.tgz"
    sha256 "6aa36dc25fe2dfb411c03ad62edb39fcbf1d4ca8b45ba17a6ad20ebc9f9e10d4"
  end

  resource "split-sequence" do
    url "https://beta.quicklisp.org/archive/split-sequence/2018-10-18/split-sequence-v1.5.0.tgz"
    sha256 "0f2c6dea1636e83aff0467c369ea41b6dca611db5825509b772530b4f27dad33"
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
    url "https://beta.quicklisp.org/archive/trivial-garbage/2018-10-18/trivial-garbage-20181018-git.tgz"
    sha256 "f48e60940fa6fedf5126d79fdb63419d4e8ff9371253b0df5a294d15d1a32e42"
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
    url "https://beta.quicklisp.org/archive/uiop/2018-07-11/uiop-3.3.2.tgz"
    sha256 "c5a77bf410cbb753d106d09c2bb884ded22ae300bc137638687727f6db5123e0"
  end

  resource "usocket" do
    url "https://beta.quicklisp.org/archive/usocket/2019-03-07/usocket-0.8.1.tgz"
    sha256 "0631b6206aef42f898863d62a656e11c42b08cd32aaee2b794d2ca8b45483c9f"
  end

  resource "uuid" do
    url "https://beta.quicklisp.org/archive/uuid/2018-08-31/uuid-20180831-git.tgz"
    sha256 "3b48ac4db2174100ad45121be09f7245dfbe3897637989b103b2de06581512c2"
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
