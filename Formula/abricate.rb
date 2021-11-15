class Abricate < Formula
  desc "Find antimicrobial resistance and virulence genes in contigs"
  homepage "https://github.com/tseemann/abricate"
  url "https://github.com/tseemann/abricate/archive/v1.0.1.tar.gz"
  sha256 "5edc6b45a0ff73dcb4f1489a64cb3385d065a6f29185406197379522226a5d20"
  license "GPL-2.0-only"
  head "https://github.com/tseemann/abricate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "703ffd651a6294a775f9136041fdab7b286cf9a5d401f6eb2f1f9ea83380b1fd"
    sha256 cellar: :any_skip_relocation, monterey:      "23eece55f6ccafde8deb7d300af8dbd42950f3c20715afe8d8ce1f5f74bf3caf"
    sha256 cellar: :any_skip_relocation, big_sur:       "226ad8e8b789110537dc87b7683f2161d47eb660ca61530454dc3da95fe22e7a"
    sha256 cellar: :any_skip_relocation, catalina:      "f2f639f89bfc29f3f4058e82ef2f1fdbf26e32ff09e3d6b542bcd3d50b26ff8f"
    sha256 cellar: :any_skip_relocation, mojave:        "40cd402e2eff5bd1988c45f2ed056bd781869e59da139efac5a738990154ca73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1758175ec977b93b4d9c6ca271a7091d9d90817c74417d00c52ca46d6237e571"
  end

  depends_on "cpanminus" => :build
  depends_on "bioperl"
  depends_on "blast"
  depends_on "openssl@1.1"
  depends_on "perl"

  uses_from_macos "unzip"

  resource "any2fasta" do
    url "https://raw.githubusercontent.com/tseemann/any2fasta/v0.4.2/any2fasta"
    sha256 "ed20e895c7a94d246163267d56fce99ab0de48784ddda2b3bf1246aa296bf249"
  end

  def install
    resource("any2fasta").stage do
      bin.install "any2fasta"
    end

    ENV.prepend "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"perl5/lib/perl5"

    ENV["OPENSSL_PREFIX"] = Formula["openssl@1.1"].opt_prefix # for Net::SSLeay

    pms = %w[JSON Path::Tiny List::MoreUtils LWP::Simple]
    system "cpanm", "--self-contained", "-l", libexec/"perl5", *pms

    libexec.install Dir["*"]
    %w[abricate abricate-get_db].each do |name|
      (bin/name).write_env_script("#{libexec}/bin/#{name}", PERL5LIB: ENV["PERL5LIB"])
    end
  end

  def post_install
    system "#{bin}/abricate", "--setupdb"
  end

  test do
    assert_match "resfinder", shell_output("#{bin}/abricate --list 2>&1")
    assert_match "--db", shell_output("#{bin}/abricate --help")
    assert_match "OK", shell_output("#{bin}/abricate --check 2>&1")
    assert_match "download", shell_output("#{bin}/abricate-get_db --help 2>&1")
    cp_r libexec/"test", testpath
    assert_match "penicillinase repressor BlaI", shell_output("#{bin}/abricate --fofn test/fofn.txt")
  end
end
