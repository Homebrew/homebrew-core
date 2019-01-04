class Jupyter < Formula
  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/c9/a9/371d0b8fe37dd231cf4b2cff0a9f0f25e98f3a73c3771742444be27f2944/jupyter-1.0.0.tar.gz"
  sha256 "d9dc4b3318f310e34c82951ea5d6683f67bed7def4b259fafbfe4f1beb1d8e5f"
  revision 5

  bottle do
    cellar :any
    rebuild 1
    sha256 "0759ea7082a96207c7160199016bd723d235d0b549daf0e36237a9ffc2ae1982" => :mojave
    sha256 "357e40d51326385dda5eed4cef3fbb3640d3955ba8010145ca45459529231114" => :high_sierra
    sha256 "8d6e8044647e0d10f26d6476a4887719fb948eed7223d4e42a5898b247335228" => :sierra
    sha256 "b19e7cf53f7d2802cf8feca141aaef74e98d2e7bc1cc06a36f5a6f237e29848a" => :el_capitan
  end

  depends_on "ipython"
  depends_on "pandoc"
  depends_on "python"
  depends_on "zeromq"

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/26/34/0f3a5efac31f27fabce64645f8c609de9d925fe2915304d1a40f544cff0e/appnope-0.1.0.tar.gz"
    sha256 "8b995ffe925347a2138d7ac0fe77155e4311a0ea6d6da4f5128fe4b3cbe5ed71"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/84/71/c8ca4f5bb1e08401b916c68003acf0a0655df935d74d93bf3f3364b310e0/backcall-0.1.0.tar.gz"
    sha256 "38ecd85be2c1e78f77fd91700c76e14667dc21e2713b63876c0eb901196e01e4"
  end

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  resource "backports.shutil_get_terminal_size" do
    url "https://files.pythonhosted.org/packages/ec/9c/368086faa9c016efce5da3e0e13ba392c9db79e3ab740b763fe28620b18b/backports.shutil_get_terminal_size-1.0.0.tar.gz"
    sha256 "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/eb/ea/58428609442130dc31d3a59010bf6cbd263a16c589d01d23b7c1e6997e3b/bleach-2.1.3.tar.gz"
    sha256 "eb7386f632349d10d9ce9d4a838b134d4731571851149f9cc2c05a9a837a9a44"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c/configparser-3.5.0.tar.gz"
    sha256 "5308b47021bc2340965c371f0f058cc6971a04502638d4244225c49d80db273a"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz"
    sha256 "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/27/e8/607697e6ab8a961fc0b141a97ea4ce72cd9c9e264adeb0669f6d194aa626/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
    sha256 "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/52/a6/8cfaaa3a1ccdebe7f3eabcf6969101e32dbdf14bfb2443d1c021130ce23c/ipykernel-4.8.2.tar.gz"
    sha256 "c091449dd0fad7710ddd9c4a06e8b9e15277da306590bc07a3a1afa6b4453c8f"
  end

  resource "ipython" do
    url "https://files.pythonhosted.org/packages/ee/01/2a85cd07f5a43fa2e86d60001c213647252662d44a0c2e3d69471a058f1b/ipython-6.4.0.tar.gz"
    sha256 "eca537aa61592aca2fef4adea12af8e42f5c335004dfa80c78caf80e8b525e5c"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "ipywidgets" do
    url "https://files.pythonhosted.org/packages/18/8c/d19f7bef501c2cc217f52f7656eb98e04f236b1511192657de74a8abf6c1/ipywidgets-7.2.1.tar.gz"
    sha256 "ab9869cda5af7ba449d8f707b29b7e97a7db97d6366805d6b733338f51096f54"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/49/2f/cdfb8adc8cfc9fc2e5673e724d9b9098619dc1a2772cc6b8af34c6b7bef9/jedi-0.12.1.tar.gz"
    sha256 "b409ed0f6913a701ed474a614a3bb46e6953639033e31f769ca7581da5bd1ec1"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "jupyter_client" do
    url "https://files.pythonhosted.org/packages/4c/df/1e8df7f4de63cc667a7a9aa234539c0419513bf94ac57d36d73b3b434786/jupyter_client-5.2.3.tar.gz"
    sha256 "27befcf0446b01e29853014d6a902dd101ad7d7f94e2252b1adca17c3466b761"
  end

  resource "jupyter_console" do
    url "https://files.pythonhosted.org/packages/cd/bb/fa8901715c009a00ea4c42897da8585189d4781c64f4617a8bd65ca01a3a/jupyter_console-5.2.0.tar.gz"
    sha256 "545dedd3aaaa355148093c5609f0229aeb121b4852995c2accfa64fe3e0e55cd"
  end

  resource "jupyter_core" do
    url "https://files.pythonhosted.org/packages/b6/2d/2804f4de3a95583f65e5dcb4d7c8c7183124882323758996e867f47e72af/jupyter_core-4.4.0.tar.gz"
    sha256 "ba70754aa680300306c699790128f6fbd8c306ee5927976cbe48adacf240c0b7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/9d/be/e06d4346cc608a01dec6bf770d7d0303a4fd6db588b318ced18f5f257145/mistune-0.8.3.tar.gz"
    sha256 "bc10c33bfdcaa4e749b779f62f60d6e12f8215c46a292d05e486b869ae306619"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/b9/a4/d0a0938ad6f5eeb4dea4e73d255c617ef94b0b2849d51194c9bbdb838412/nbconvert-5.3.1.tar.gz"
    sha256 "12b1a4671d4463ab73af6e4cbcc965b62254e05d182cd54995dda0d0ef9e2db9"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/6e/0e/160754f7ae3e984863f585a3743b0ed1702043a81245907c8fae2d537155/nbformat-4.4.0.tar.gz"
    sha256 "f7494ef0df60766b7cabe0a3651556345a963b74dbc16bc7c18479041170d402"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/ac/50/4e8fc418c6b4beee3b0c39d38f82a1684bf5c4c9a216cc017e8a498686d6/notebook-5.5.0.tar.gz"
    sha256 "fa915c231e64a30d19cc2c70ccab6444cbaa93e44e92b5f8233dd9147ad0e664"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/4c/ea/236e2584af67bb6df960832731a6e5325fd4441de001767da328c33368ce/pandocfilters-1.4.2.tar.gz"
    sha256 "b3dd70e169bb5449e6bc6ff96aea89c5eea8c5f6ab5e207fc2f521a2cf4a0da9"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/29/c1/fd8a3e5eec85bf160c2b1ea369fdfa585620cf753db021d5db895801e701/parso-0.3.0.tar.gz"
    sha256 "d250235e52e8f9fc5a80cc2a5f804c9fefd886b2e67a2b1099cf085f403f8e33"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/db/a8/7d6439c1aec525ed70810abee5b7d7f3aa35347f59bc28343e8f62019aa2/pathlib2-2.3.2.tar.gz"
    sha256 "8eb170f8d0d61825e09a95b38be068299ddeda82f35e96c3301a8a5e7604cb83"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/09/0e/75f0c093654988b8f17416afb80f7621bcf7d36bbd6afb4f823acdb4bcdc/pexpect-4.5.0.tar.gz"
    sha256 "9f8eb3277716a01faafaba553d629d3d60a1a624c7cf45daa600d2148c30020c"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/69/fe/dd137d84daa0fd13a709e448138e310d9ea93070620c9db5454e234af525/pickleshare-0.7.4.tar.gz"
    sha256 "84a9257227dfdd6fe1b4be1319096c20eb85ff1e82c7932f36efccfe1b09737b"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/8a/ad/cf6b128866e78ad6d7f1dc5b7f99885fb813393d9860778b2984582e81b5/prompt_toolkit-1.0.15.tar.gz"
    sha256 "858588f1983ca497f1cf4ffde01d978a3ea02b01c8a26a8bbc5cd2e66d816917"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/51/83/5d07dc35534640b06f9d9f1a1d2bc2513fb9cc7595a1b0e28ae5477056ce/ptyprocess-0.5.2.tar.gz"
    sha256 "e64193f0047ad603b71f202332ab5527c5e52aa7c8b609704fc28c0dc20c4365"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/a0/b0/a4e3241d2dee665fea11baec21389aec6886655cd4db7647ddf96c3fad15/python-dateutil-2.7.3.tar.gz"
    sha256 "e27001de32f627c22380a688bcc43ce83504a7bc5da472209b4c70f02829f0b8"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/9f/f6/85a33a25128a4a812c3482547e3d458eebdb19ee0b4699f9199cdb2ad731/pyzmq-17.0.0.tar.gz"
    sha256 "0145ae59139b41f65e047a3a9ed11bbc36e37d5e96c64382fcdff911c4d8c3f0"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/13/bb/e541b74230bbf7a20a3949a2ee6631be299378a784f5445aa5d0047c192b/scandir-1.7.tar.gz"
    sha256 "b2d55be869c4f716084a19b1e16932f0769711316ba62de941320bf2be84763d"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/13/2e/ea40de0304bb1dc4eb309de90aeec39871b9b7c4bd30f1a3cdcb3496f5c0/Send2Trash-1.5.0.tar.gz"
    sha256 "60001cc07d707fe247c94f74ca6ac0d3255aabcb930529690897ca2a39db28b2"
  end

  resource "simplegeneric" do
    url "https://files.pythonhosted.org/packages/3d/57/4d9c9e3ae9a255cd4e1106bb57e24056d3d0709fc01b2e3e345898e49d5b/simplegeneric-0.8.1.zip"
    sha256 "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/67/84/ce0ebd0f60e1cbe040f8e065eef7063855d59d9cf5e6438b3f8439fc7e15/terminado-0.8.1.tar.gz"
    sha256 "55abf9ade563b8f9be1f34e4233c7b7bde726059947a593322e8a553cc4c067a"
  end

  resource "testpath" do
    url "https://files.pythonhosted.org/packages/f4/8b/b71e9ee10e5f751e9d959bc750ab122ba04187f5aa52aabdc4e63b0e31a7/testpath-0.3.1.tar.gz"
    sha256 "0d5337839c788da5900df70f8e01015aec141aa3fe7936cb0d0a2953f7ac7609"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/d1/3be271ae5eba9fb59df63c9891fdc7d8044b999e8ac145994cdbfd2ae66a/tornado-5.0.2.tar.gz"
    sha256 "1b83d5c10550f2653380b4c77331d6f8850f287c4f67d7ce1e1c639d9222fbc7"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/a5/98/7f5ef2fe9e9e071813aaf9cb91d1a732e0a68b6c44a32b38cb8e14c3f069/traitlets-4.3.2.tar.gz"
    sha256 "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "widgetsnbextension" do
    url "https://files.pythonhosted.org/packages/da/c4/53da2ddb67be3610e985f9b1ffa8cce45cef2ef3b8d2cd42009235394a65/widgetsnbextension-3.2.1.tar.gz"
    sha256 "5417789ee6064ff515fd10be24870660af3561c02d3d48b26f6f44285d0f70cc"
  end

  def install
    ENV["JUPYTER_PATH"] = etc/"jupyter"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    # gather packages to link based on options
    linked = %w[jupyter_core jupyter_client nbformat ipykernel jupyter_console
                nbconvert notebook]
    dependencies = resources.map(&:name).to_set - linked

    # install dependent packages
    dependencies.each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # install main packages and link with env script
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    linked.each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :JUPYTER_PATH => ENV["JUPYTER_PATH"], :PYTHONPATH => ENV["PYTHONPATH"])

    # remove bundled kernel
    rm_rf Dir["#{libexec}/share/jupyter/kernels"]
  end

  def caveats; <<~EOS
    Additional kernels can be installed into the shared jupyter directory
      #{etc}/jupyter
  EOS
  end

  test do
    assert_match "python3", shell_output("#{bin}/jupyter kernelspec list")

    (testpath/"console.exp").write <<~EOS
      spawn #{bin}/jupyter-console
      expect "In "
      send "exit\r"
    EOS
    assert_match "Jupyter console", shell_output("expect -f console.exp")

    (testpath/"notebook.exp").write <<~EOS
      spawn #{bin}/jupyter-notebook --no-browser
      expect "NotebookApp"
    EOS
    assert_match "NotebookApp", shell_output("expect -f notebook.exp")

    (testpath/"nbconvert.ipynb").write <<~EOS
      {
        "cells": []
      }
    EOS
    system bin/"jupyter-nbconvert", "nbconvert.ipynb"
    assert_predicate testpath/"nbconvert.html", :exist?, "Failed to export HTML"
  end
end
