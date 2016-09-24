class Mdv < Formula
  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://github.com/axiros/terminal_markdown_viewer/archive/v0.1.2.tar.gz"
  sha256 "547f223658714d130f3a642d2aa366239f16d05ae93caf54e87f3d07455c5f1c"

  head "https://github.com/axiros/terminal_markdown_viewer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95f4afb24259a3131f3248b33ab2797ecea78158c6e20c201225d71266324232" => :el_capitan
    sha256 "69d1d3de00b7d27fc5de556a61f178ff3d5fcbbfef50afd621eadd8595c43928" => :yosemite
    sha256 "73a5c302f5685123fbd48d14dae77c3f17ac57f970786f944b819e5dfad7f2e9" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.6.5.tar.gz"
    sha256 "8d94cf6273606f76753fcb1324623792b3738c7612c2b180c85cc5e88642e560"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.tar.gz"
    sha256 "13a0ef5fafd7b16cf995bc28fe7aab0780dab1b2fda0fc89e033709af8b8a47b"
  end

  resource "yaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[markdown pygments yaml].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    (libexec/"bin").install %w[mdv.py docopt.py tabulate.py ansi_tables.json]

    bin.install_symlink "mdv.py" => "mdv"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.md").write <<-EOF.undent
    # Header 1
    ## Header 2
    ### Header 3
    EOF
    system "#{bin}/mdv", "#{testpath}/test.md"
  end
end
