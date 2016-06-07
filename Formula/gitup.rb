class Gitup < Formula
  desc "Update multiple git repositories at once"
  homepage "https://github.com/earwig/git-repo-updater"
  url "https://github.com/earwig/git-repo-updater.git",
    :revision => "10494e677bba19622acfa3fc62093a06451c8562",
    :tag => "v0.3"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "51b4abede9028a4762fbdd2983a11532b65826e2a566c7e2519d3346f5fdbb0f" => :el_capitan
    sha256 "0b5f3064bcdc561e931afbd126bd472a7d7ad87a68c02f5c03defbdb9c140d85" => :yosemite
    sha256 "c0b86146ca84fd6962066a3bc11634d504c97df17bcf113f77ea3ff16543aa41" => :mavericks
    sha256 "030291b81b361518a13917c16235fac9bb06ce12ce8f9c7ebb8ae38a9e4ad531" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "smmap" do
    url "https://pypi.python.org/packages/source/s/smmap/smmap-0.9.0.tar.gz"
    sha256 "0e2b62b497bd5f0afebc002eda4d90df9d209c30ef257e8673c90a6b5c119d62"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "gitdb" do
    url "https://pypi.python.org/packages/source/g/gitdb/gitdb-0.6.4.tar.gz"
    sha256 "a3ebbc27be035a2e874ed904df516e35f4a29a778a764385de09de9e0f139658"
  end

  resource "GitPython" do
    url "https://pypi.python.org/packages/47/28/30f51df811ccdde2f719c034afc1cd1b036dcbb94ecf93ee61af25fe1738/GitPython-2.0.5.tar.gz"
    sha256 "20f3c90fb8a11edc52d363364fb0a116a410c7b7bdee24a433712b5413d1028e"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[smmap colorama gitdb GitPython].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    def prepare_repo(uri, local_head)
      system "git", "init"
      system "git", "remote", "add", "origin", uri
      system "git", "fetch", "origin"
      system "git", "checkout", local_head
      system "git", "reset", "--hard"
      system "git", "checkout", "-b", "master"
      system "git", "branch", "--set-upstream-to=origin/master", "master"
    end

    first_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "first" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", first_head_start)
    end

    second_head_start = "f863d5ca9e39e524e8c222428e14625a5053ed2b"
    mkdir "second" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-cask-games.git", second_head_start)
    end

    system bin/"gitup", "first", "second"

    first_head = `cd first ; git rev-parse HEAD`.split.first
    assert_not_equal first_head, first_head_start

    second_head = `cd second ; git rev-parse HEAD`.split.first
    assert_not_equal second_head, second_head_start

    third_head_start = "f47ab45abdbc77e518776e5dc44f515721c523ae"
    mkdir "third" do
      prepare_repo("https://github.com/pr0d1r2/homebrew-contrib.git", third_head_start)
    end

    system bin/"gitup", "--add", "third"

    system bin/"gitup"
    third_head = `cd third ; git rev-parse HEAD`.split.first
    assert_not_equal third_head, third_head_start

    assert_match %r{#{Dir.pwd}/third}, `#{bin}/gitup --list`.strip

    system bin/"gitup", "--delete", "#{Dir.pwd}/third"
  end
end
