class AwsShell < Formula
  desc "Integrated shell for working with the AWS CLI."
  homepage "https://github.com/awslabs/aws-shell"

  stable do
    url "https://pypi.python.org/packages/3f/d1/0f5bdb9833f2a57095bc133fa603de8e8931f6ca44653bd56afda8148e0f/aws-shell-0.1.1.tar.gz"
    sha256 "653f085d966b4ed3b3581b7bb85f6f0bb1e8a3bfd852a3333596082a5ba689df"

    resource "awscli" do
      url "https://pypi.python.org/packages/8e/24/747a4920001486e25c0d014acf42cae95d1bdde0aef6575f8c7e4e02fb6b/awscli-1.10.60.tar.gz"
      sha256 "555a7fa397e1ff2125da7e5a6eb30ec1f0e919121b1ebb426726d72da1d8da34"
    end

    resource "boto3" do
      url "https://pypi.python.org/packages/37/1a/e271b2937c05c1da265415103725e0610fb96871a2d7ddf68b999ac5db8f/boto3-1.4.0.tar.gz#md5=4b5454e8d29dede99092616023828a21"
      sha256 "c365144fb98d022ad6f6cdeb1abf8a4849f1a135e3c4ef78ef5053982ed914b3"
    end

    resource "botocore" do
      url "https://pypi.python.org/packages/c6/fe/66127b8c686384653512f49bf02d546dfb2aac7ef1f034d9c9021c33356a/botocore-1.4.50.tar.gz"
      sha256 "83b02699c272ff412dbb7796c97a3fec6ee696a85e65576c932172938c6dfdae"
    end

    resource "colorama" do
      url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
      sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
    end

    resource "configobj" do
      url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
      sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
    end

    resource "docutils" do
      url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
      sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
    end

    resource "futures" do
      url "https://pypi.python.org/packages/source/f/futures/futures-2.2.0.tar.gz"
      sha256 "151c057173474a3a40f897165951c0e33ad04f37de65b6de547ddef107fd0ed3"
    end

    resource "jmespath" do
      url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
      sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
    end

    resource "prompt_toolkit" do
      url "https://pypi.python.org/packages/dd/55/2fb4883d2b21d072204fd21ca5e6040faa253135554590d0b67380669176/prompt_toolkit-1.0.7.tar.gz"
      sha256 "ef0b8188179fe7d052161ed274b43e18f5a680ff84d01462293b327e1668d2ef"
    end

    resource "pyasn1" do
      url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
      sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
    end

    resource "Pygments" do
      url "https://pypi.python.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
      sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
    end

    resource "python-dateutil" do
      url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
      sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
    end

    resource "rsa" do
      url "https://pypi.python.org/packages/source/r/rsa/rsa-3.2.3.tar.gz"
      sha256 "14db288cc40d6339dedf60d7a47053ab004b4a8976a5c59402a211d8fc5bf21f"
    end

    resource "six" do
      url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
      sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
    end

    resource "s3transfer" do
      url "https://pypi.python.org/packages/d4/6e/1e9014fa7d3e8cd1f0c717321cea628606f61d24991c8945eb464ae4b325/s3transfer-0.1.3.tar.gz"
      sha256 "af2e541ac584a1e88d3bca9529ae784d2b25e5d448685e0ee64f4c0e1e017ed2"
    end

    resource "wcwidth" do
      url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.6.tar.gz"
      sha256 "dcb3ec4771066cc15cf6aab5d5c4a499a5f01c677ff5aeb46cf20500dccd920b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "823b42cd34e333d78f304d31e6cfa943fc7516a3b5312a1f8db0c9588c4b5acb" => :el_capitan
    sha256 "5959d47987ad840f984e7810bd16d7337c1b83a89b008c1f82a42bf08c60bc39" => :yosemite
    sha256 "346a99f1f94562dfa2ee348d9b4a6c565dc643bf83498742e592e0606ad3fb98" => :mavericks
  end

  head do
    url "https://github.com/awslabs/aws-shell.git"

    resource "awscli" do
      url "https://github.com/aws/aws-cli.git", :branch => "develop"
    end

    resource "boto3" do
      url "https://github.com/boto/boto3.git", :branch => "develop"
    end

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => "develop"
    end

    resource "colorama" do
      url "https://github.com/tartley/colorama.git",
      :tag => "v0.3.3",
      :revision => "5906b2604223f3a3bdf4497244fc8861b89dbda6"
    end

    resource "configobj" do
      url "https://github.com/DiffSK/configobj.git", :branch => "release"
    end

    resource "docutils" do
      url "https://github.com/chevah/docutils.git", :branch => "docutils-0.12-chevah"
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => "develop"
    end

    resource "python-dateutil" do
      url "https://github.com/dateutil/dateutil.git",
      :tag => "2.4.2",
      :revision => "248106da8e5f4023210d7a18d30b176577916b4f"
    end

    resource "rsa" do
      url "https://github.com/sybrenstuvel/python-rsa.git"
    end

    resource "s3transfer" do
      url "https://github.com/boto/s3transfer.git", :branch => "develop"
    end

    resource "wcwidth" do
      url "https://github.com/jquast/wcwidth.git"
    end
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/aws-shell", "--help"
  end
end
